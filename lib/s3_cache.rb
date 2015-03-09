module S3Cache

  def self.set_credentials
    # The following should be done automatically by the gem, according to the documentation 
    # Aws.config(
    #   access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    #   secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    #   region: ENV['AWS_REGION']
    # )
  end

  def self.fetch(cache_key, bucket_name, expires_in = 14.days)
    set_credentials
    
    begin
      return Aws::S3::Client.new.get_object(bucket: bucket_name, key: cache_key).body.read
    rescue # Aws::S3::Errors::NoSuchKey
       return nil
    end
  end
  
  def self.write(cache_key, value, bucket_name, expires_in = 14.days) 
    set_credentials
    
    bucket = Aws::S3::Resource.new.bucket(bucket_name)
    bucket.objects[cache_key].write(value, acl: :public_read)
  end
  
end
