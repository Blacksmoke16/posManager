# frozen_string_literal: true
namespace :pos do
  desc 'Call function to updates POSs'
  task POSs: :environment do
    Pos.delete_all
    Silo.delete_all
    start_time = Time.now
    puts "Starting task....#{Time.now}"
		Rake::Task['pos:sovList'].execute

    Corp.all.each do |corp|
      puts "Start posList for #{corp.corpName}"
      Rake::Task['pos:posList'].execute keyID: corp.keyID, vCode: corp.vCode
      puts 'Start silos'
      Rake::Task['pos:silos'].execute keyID: corp.keyID, vCode: corp.vCode
      puts 'Start coords'
      Rake::Task['pos:coords'].execute keyID: corp.keyID, vCode: corp.vCode, corpID: corp.corpID
    end
    puts 'Start silo2pos'
    Rake::Task['pos:silo2pos'].execute
    puts 'Start siphons'
    Rake::Task['pos:siphons'].execute
    puts 'Start details'
    Rake::Task['pos:details'].execute

    end_time = Time.now
    puts "Task completed in: #{end_time - start_time}"
  end

  desc 'Call function to updates POS Details'
  task details: :environment do
    start_time = Time.now
    Corp.all.each do |corp|
      Pos.where(corpID: corp.corpID).pluck(:itemID).each do |id|
        get_pos_details(corp.keyID, corp.vCode, id)
      end
    end
    end_time = Time.now
    puts end_time - start_time
  end

  desc 'Updates pos table towers'
  task :posList, [:keyID, :vCode] => :environment do |_t, args|
    include PosManagerHelper

    pos_data = []
    api_id = args[:keyID]
    api_vcode = args[:vCode]

    corp_url = "https://api.eveonline.com/Corp/CorporationSheet.xml.aspx?keyID=#{api_id}&vCode=#{api_vcode}"
    doc = Nokogiri::XML(open(corp_url))

    corp_id = doc.xpath('//corporationID').first.text
    alliance_id = doc.xpath('//allianceID').first.text

    pos_url = "https://api.eveonline.com/Corp/StarbaseList.xml.aspx?keyID=#{api_id}&vCode=#{api_vcode}"
    doc = Nokogiri::XML(open(pos_url))

    doc.xpath('//row').each do |row|
      next unless row.xpath('@moonID').first.text != '0'
      state = get_pos_state(row.xpath('@state').first.text)

      silo_capacity, fuel_type, fuel_type_name = get_pos_fuel_details(row.xpath('@typeID').first.value.to_i)

      pos_data <<
        {
          itemID: row.xpath('@itemID').first.value,
          typeID: row.xpath('@typeID').first.value,
          locationID: row.xpath('@locationID').first.value,
          moonID: row.xpath('@moonID').first.value,
          state: state,
          stateTimestamp: row.xpath('@stateTimestamp').first.value,
          onlineTimestamp: row.xpath('@onlineTimestamp').first.value,
          corpID: corp_id,
          allianceID: alliance_id,
          capacity: silo_capacity,
          fuelType: fuel_type,
          fuelTypeName: fuel_type_name
        }
    end

    pos_list = []
    pos_data.each.with_index do |_obj, idx|
      system = System.find(pos_data[idx][:locationID])
      item = Item.find(pos_data[idx][:typeID])

      pos_list << Pos.new(
        itemID: pos_data[idx][:itemID],
        typeID: pos_data[idx][:typeID],
        typeName: item.typeName,
        locationID: pos_data[idx][:locationID],
        locationName: Moon.find(pos_data[idx][:moonID]).itemName,
        regionID: system.region.regionID,
        regionName: system.region.regionName,
        constellationID: system.constellation.constellationID,
        constellationName: system.constellation.constellationName,
        moonID: pos_data[idx][:moonID],
        state: pos_data[idx][:state],
        siloCapacity: pos_data[idx][:capacity],
        stateTimestamp: pos_data[idx][:stateTimestamp],
        onlineTimestamp: pos_data[idx][:onlineTimestamp],
        corpID: pos_data[idx][:corpID],
        allianceID: pos_data[idx][:allianceID],
        fuelType: pos_data[idx][:fuelType],
        fuelTypeName: pos_data[idx][:fuelTypeName],
        posCapacity: item.capacity
      )
    end
    Pos.import pos_list
  end

  desc 'Refreshes silo table'
  task :silos, [:keyID, :vCode] => :environment do |_t, args|
    require 'open-uri'

    silo_data = []
    api_id = args[:keyID]
    api_vcode = args[:vCode]

    corp_url = "https://api.eveonline.com/Corp/CorporationSheet.xml.aspx?keyID=#{api_id}&vCode=#{api_vcode}"
    doc = Nokogiri::XML(open(corp_url))

    corp_id = doc.xpath('//corporationID').first.text

    asset_url = "https://api.eveonline.com/corp/AssetList.xml.aspx?keyID=#{api_id}&vCode=#{api_vcode}"
    doc = Nokogiri::XML(open(asset_url))

    doc.xpath('//row[@typeID=14343][@flag=0]').each do |row|
      next if row.xpath('./rowset/row/@typeID').empty?
      item = Item.find(row.xpath('./rowset/row/@typeID').first.value)

      silo_data << Silo.new(
        itemID: row.xpath('@itemID').first.value,
        locationID: row.xpath('@locationID').first.value,
        corpID: corp_id,
        gooTypeID: row.xpath('./rowset/row/@typeID').first.value,
        gooGroupID: item.group.groupID,
        gooAmount: row.xpath('./rowset/row/@quantity').first.value,
        gooName: item.typeName,
        gooVolume: item.volume
      )
    end
    Silo.import silo_data
  end

  desc 'assigns silos to POSsa'
  task silo2pos: :environment do
    Silo.all.each do |silo|
      pos = Pos.where(locationID: silo[:locationID]).find { |p| dist_within?(p, silo, 300_000) }
      if pos.nil?
        puts silo.inspect
        Silo.update(silo[:itemID], posID: 0)
      else
        Silo.update(silo[:itemID], posID: pos[:itemID])
      end
    end
  end

  desc 'Check for siphons'
  task siphons: :environment do
    Pos.all.each do |pos|
      siphon = (pos.silos.sum(:gooAmount) % 100).positive?
      siphon = false if pos.silos.group(:gooName).length > 1
      Pos.update(pos[:itemID], siphon: siphon)
    end
  end

  desc 'Updates Coords'
  task :coords, [:keyID, :vCode, :corpID] => :environment do |_t, args|
    require 'open-uri'

    api_id = args[:keyID]
    api_vcode = args[:vCode]
    pos_ids = Pos.where(corpID: args[:corpID]).pluck(:itemID)
    silo_ids = Silo.where(corpID: args[:corpID]).pluck(:itemID)

    pos_ids.each_slice(100).each do |value|
      pos_url = "https://api.eveonline.com/corp/Locations.xml.aspx?keyID=#{api_id}&vCode=#{api_vcode}&IDs=#{value.join(',')}"
      doc = Nokogiri::XML(open(pos_url))

      doc.xpath('//row').each do |row|
        id = row.xpath('@itemID').first.value
        x = row.xpath('@x').first.value
        y = row.xpath('@y').first.value
        z = row.xpath('@z').first.value
        name = row.xpath('@itemName')

        Pos.update(id, x: x, y: y, z: z, itemName: name)
      end
    end

    silo_ids.each_slice(100).each do |value|
      silo_url = "https://api.eveonline.com/corp/Locations.xml.aspx?keyID=#{api_id}&vCode=#{api_vcode}&IDs=#{value.join(',')}"
      doc = Nokogiri::XML(open(silo_url))

      doc.xpath('//row').each do |row|
        id = row.xpath('@itemID').first.value
        x = row.xpath('@x').first.value
        y = row.xpath('@y').first.value
        z = row.xpath('@z').first.value
        name = row.xpath('@itemName')

        Silo.update(id, siloName: name, x: x, y: y, z: z)
      end
		end
	end

	desc 'Update Sov List'
	task sovList: :environment do
		 require 'open-uri'
		 start_time = Time.now
		 puts "Starting task....#{Time.now}"

		 Sov.delete_all
		 system_data = []

		 sov_url = 'https://api.eveonline.com/map/Sovereignty.xml.aspx'
		 begin
				puts 'Fetch sov data'
				doc = Nokogiri::XML(open(sov_url))
		 rescue *ERRORS => e
				Kernel.abort("Error:  #{e.message}")
		 end

		 puts 'Parse sov data'
		 doc.xpath('//row').each do |system|
				system_data << Sov.new(
						solarSystemID: system.xpath('@solarSystemID').first.value,
						solarSystemName: system.xpath('@solarSystemName'),
						corpID: system.xpath('@corporationID').first.value,
						allianceID: system.xpath('@allianceID').first.value,
						factionID: system.xpath('@factionID').first.value
				)
		 end

		 puts 'Import sov data'
		 Sov.import system_data

		 end_time = Time.now
		 puts "Task completed in: #{end_time - start_time}"
	end

  # !todo Reduce dist_within? function's ABC size
  # @param [Object] p1 - requires [:x], [:y], and [:z]
  # @param [Object] p2 - requires [:x], [:y], and [:z]
  def dist_within?(p1, p2, limit)
    p1 = { x: p1[:x], y: p1[:y], z: p1[:z] }
    p2 = { x: p2[:x], y: p2[:y], z: p2[:z] }
    dists = p1.map { |k, _v| p1[k] - p2[k] }
    return false if p1.nil? || p2.nil? || dists.map { |v| v.abs > limit }.any?
    Math.sqrt(dists.inject { |acc, elem| acc + elem * elem }) < limit
  end

  def get_pos_details(api_id, api_vcode, id)
    include PosManagerHelper
    fuel_consumption, stront_consumption, sov_bonus = get_pos_base_amounts(id)

    begin
      detail_url = "https://api.eveonline.com/corp/StarbaseDetail.xml.aspx?keyID=#{api_id}&vCode=#{api_vcode}&itemID=#{id}"
      doc = Nokogiri::XML(open(detail_url))
    rescue OpenURI::HTTPError => ex
      puts "ERROR for POSID #{id}: #{ex}"
      return
    end

    stront_amount, fuel_amount, corp, alliance = get_pos_fuel_quantities(doc)

    Pos.update(id,
               allowAllianceUsage: alliance,
               allowCorporationUsage: corp,
               sovBonus: sov_bonus,
               fuelAmount: fuel_amount,
               strontAmount: stront_amount,
               fuelConsumption: fuel_consumption.ceil,
               strontConsumption: stront_consumption)
  end
end
