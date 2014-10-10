namespace :carrierwave do

  desc "Recreates carrierwave thumbnails"
  task :recreate_versions do
    require File.expand_path("../../config/environment", File.dirname(__FILE__))

    num_processed = 0
    total = Attachment.count

    print "\n\rRecreating versions: #{num_processed}/#{total}"

    # .where(["attachment LIKE ?", "ec4908%"])
    Attachment.find_each do |art|
      file = art.attachment
      versions = [:micro, :thumb]

      versions.each do |version|
        path = file.send(version).path
        FileUtils.cp(path, path + ".bak") if File.exists?(path)
      end

      begin
        file.recreate_versions!(*versions)
      rescue StandardError => e
        puts "\nFailed to recreate versions for %p\n#{e.message}" % [file]
        debugger
        1
      end

      print "\rRecreating versions: #{num_processed += 1}/#{total}"
    end

    puts "\nDone"
  end

end
