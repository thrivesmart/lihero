module S3Cache

  def self.set_credentials
    AWS.config(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  def self.fetch(cache_key, bucket, expires_in = 14.days)
    set_credentials
    bucket = Aws::S3::Resource.new.bucket(bucket)
    
    if bucket.objects[cache_key].exists? # LINKEDIN[:aws_cache_bucket]
      return bucket.objects[cache_key].read # LINKEDIN[:aws_cache_bucket]
    else
      return nil
    end
  end
  
  def self.write(cache_key, value, bucket, expires_in = 14.days) 
    set_credentials
    
    bucket = Aws::S3::Resource.new.bucket(bucket)
    bucket.objects[cache_key].write(value, acl: :public_read)
  end
  
end
