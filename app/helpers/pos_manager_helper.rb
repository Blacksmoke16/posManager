# frozen_string_literal: true
module PosManagerHelper
  def get_pos_base_amounts(id)
    pos = Pos.find(id)
    type = pos.typeID
    fuel_consumption = 0
    stront_consumption = 0

    if [12_235, 12_236, 16_213, 16_214]
       .include? type # normal larges
      fuel_consumption = 40
      stront_consumption = 400
    elsif [27_539, 27_530, 27_533, 27_780, 27_536]
          .include? type # faction (angle, blood, guristas, sansha, serpentis)
      fuel_consumption = 36
      stront_consumption = 400
    elsif [27_532, 27_540, 27_535, 27_538, 27_786]
          .include? type # rare faction (domination, dark blood, dread guristas, true sansha, shadow)
      fuel_consumption = 32
      stront_consumption = 400
    end

    if [20_059, 20_061, 20_063, 20_065]
       .include? type # normal mediums
      fuel_consumption = 20
      stront_consumption = 200
    elsif [27_607, 27_589, 27_595, 27_782, 27_601]
          .include? type # faction (angle, blood, guristas, sansha, serpentis)
      fuel_consumption = 18
      stront_consumption = 200
    elsif [27_591, 27_609, 27_597, 27_603, 27_788]
          .include? type # rare faction (domination, dark blood, dread guristas, true sansha, shadow)
      fuel_consumption = 16
      stront_consumption = 200
    end

    if [20_060, 20_062, 20_064, 20_066]
       .include? type # normal smalls
      fuel_consumption = 10
      stront_consumption = 100
    elsif [27_592, 27_598, 27_604, 27_610, 27_784]
          .include? type # faction (angle, blood, guristas, sansha, serpentis)
      fuel_consumption = 9
      stront_consumption = 100
    elsif [27_594, 27_600, 27_606, 27_612, 27_790]
          .include? type # rare faction (domination, dark blood, dread guristas, true sansha, shadow)
      fuel_consumption = 8
      stront_consumption = 100
    end

    sov_bonus = pos.allianceID.to_s == Sov.find(pos.locationID).allianceID.to_s if Sov.exists?(solarSystemID: pos.locationID)

    if sov_bonus
      fuel_consumption *= 0.75
      stront_consumption *= 0.75
    end

    [fuel_consumption, stront_consumption, sov_bonus]
  end

  def get_pos_fuel_details(id)
    if [12_235, 20_059, 20_060, 27_532, 27_591, 27_594, 27_530, 27_589, 27_592,
        27_780, 27_782, 27_784, 27_786, 27_788, 27_790].include? id # amarr 4 faction
      silo_capacity = 30_000
      fuel_type = 4247
      fuel_type_name = 'Helium Fuel Block'
    elsif [16_213, 20_061, 20_062, 27_533, 27_595, 27_598, 27_535, 27_597, 27_600].include? id # caldari 2 faction
      silo_capacity = 20_000
      fuel_type = 4051
      fuel_type_name = 'Nitrogen Fuel Block'
    elsif [12_236, 20_063, 20_064, 27_538, 27_603, 27_606, 27_536, 27_601, 27_604].include? id # gallente 2 faction
      silo_capacity = 40_000
      fuel_type = 4312
      fuel_type_name = 'Oxygen Fuel Block'
    elsif [16_214, 20_065, 20_066, 27_540, 27_609, 27_612, 27_539, 27_607, 27_610].include? id # Minmatar 2 faction
      silo_capacity = 20_000
      fuel_type = 4246
      fuel_type_name = 'Hydrogen Fuel Block'
    end

    [silo_capacity, fuel_type, fuel_type_name]
  end

  def get_pos_state(state)
    if state == '0'
      state = 'Unanchored'
    elsif state == '1'
      state = 'Anchored'
    elsif state == '2'
      state = 'Onlining'
    elsif state == '3'
      state = 'Reinforced'
    elsif state == '4'
      state = 'Online'
    end

    state
  end

  def get_pos_fuel_quantities(doc)
    corp = doc.xpath('//allowCorporationMembers').children.first.text
    alliance = doc.xpath('//allowAllianceMembers').children.first.text

    stront_amount = if doc.xpath('//row[@typeID=16275]').empty?
                      0
                    else
                      doc.xpath('//row[@typeID=16275]/@quantity').first.value
                    end

    fuel_amount = if doc.xpath('//row[@typeID!=16275]').empty?
                    0
                  else
                    doc.xpath('//row[@typeID!=16275]/@quantity').first.value
                  end

    [stront_amount, fuel_amount, corp, alliance]
  end
end
