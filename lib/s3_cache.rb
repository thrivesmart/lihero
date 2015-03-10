module S3Cache

  def self.fetch_credentials
    # The following should be done automatically by the gem, according to the documentation 
    creds = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  end

  def self.fetch(cache_key, bucket_name, expires_in = 14.days)
    begin
      return Aws::S3::Client.new(credentials: fetch_credentials).get_object(bucket: bucket_name, key: cache_key).body.read
    rescue Aws::S3::Errors::NoSuchKey
       return nil
    end
  end
  
  def self.write(cache_key, value, bucket_name, expires_in = 14.days)
    hash = {bucket: bucket_name, key: cache_key, body: value, acl: :public_read}
    Aws::S3::Client.new(credentials: fetch_credentials).put_object(bucket: bucket_name, key: cache_key, body: value, acl: 'public-read')
  end
  
end
