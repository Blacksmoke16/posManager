# frozen_string_literal: true
namespace :icon do
  desc 'Compiles material-icons file for assets; for material icons only.'
  task compile: :environment do
    # compile a list of available icons
    icons_path = Rails.root.join('lib', 'assets', 'icons', '*.svg')
    available = {}
    files = Dir.glob(icons_path).select { |e| File.file? e }
    files.each do |file_name|
      File.open(file_name) do |file|
        file.each_line do |line|
          if line.include? '<g id'
            name = line.split('id=')[1].split('"')[1]
            available[name] = line
          end
        end
      end
    end

    assets_path = Rails.root.join('app', 'assets', '**', '*.{erb,html,coffee}')
    # compile a list of necessary icons
    icon_list = []
    files = Dir.glob(assets_path).select { |e| File.file? e }
    files.each do |file_name|
      File.open(file_name) do |file|
        file.each_line do |line|
          available.each do |name, _icon|
            next unless line.include? name
            icon_list.push(icon: name, file: file.path)
          end
        end
      end
    end

    icon_list = icon_list.uniq { |i| i[:icon] }.sort_by { |i| i[:icon] }
    puts 'Icons to write:', icon_list

    missing = []

    # write the necessary icons to the icon file
    icon_file = Rails.root.join('app', 'assets', 'images', 'icons', 'material-icons.svg')
    file = File.open(icon_file, 'w')
    file.puts('<svg>')
    file.puts('<defs>')
    icon_list.each do |i|
      if available[i[:icon]].nil?
        missing.push(i)
      else
        file.puts(available[i[:icon]])
      end
    end
    file.puts('</defs>')
    file.puts('</svg>')
    file.close

    # display missing icons + icons from interpolation for reference
    puts 'Unable to find icons for:', missing unless missing.empty?
  end
end
