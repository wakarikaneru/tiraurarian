#!bin/rails runner

User.where.not(avatar_file_name: nil).find_each do |user|
  # This step helps us catch any attachments we might have uploaded that
  # don't have an explicit file extension in the filename
  image = user.avatar_file_name
  ext = File.extname(image)
  hash = user.avatar.hash_key

  # this url pattern can be changed to reflect whatever service you use
  source_image_url = "/system/images/#{hash}#{ext}"
  dest_image_url = "/system/images/#{image}"

  FileUtils.cp(source_image_url, dest_image_url)
end
