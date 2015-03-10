require 's3_cache'

module LinkedinSearch
  SEARCH_COLUMNS = %w(distance id first-name last-name headline location current-share summary specialties associations positions phone-numbers im-accounts twitter-accounts primary-twitter-account main-address picture-url site-standard-profile-request)
  PROFILE_COLUMNS = %w(id first-name last-name maiden-name formatted-name phonetic-first-name phonetic-last-name headline location industry distance relation-to-viewer:(related-connections:(distance,id,first-name,last-name,headline,location,current-share,summary,specialties,associations,positions,phone-numbers,im-accounts,twitter-accounts,primary-twitter-account,main-address,picture-url,site-standard-profile-request)) last-modified-timestamp current-share num-connections num-connections-capped summary specialties proposal-comments associations honors interests positions publications patents languages skills certifications educations courses volunteer three-current-positions three-past-positions num-recommenders recommendations-received phone-numbers im-accounts twitter-accounts primary-twitter-account bound-account-types following job-bookmarks group-memberships date-of-birth main-address member-url-resources picture-url site-standard-profile-request public-profile-url related-profile-views)
  ME_COLUMNS = %w(id email-address first-name last-name maiden-name formatted-name phonetic-first-name phonetic-last-name headline location industry last-modified-timestamp current-share num-connections num-connections-capped summary specialties proposal-comments associations honors interests positions publications patents languages skills certifications educations courses volunteer three-current-positions three-past-positions num-recommenders recommendations-received phone-numbers im-accounts twitter-accounts primary-twitter-account bound-account-types following job-bookmarks group-memberships date-of-birth main-address member-url-resources picture-url site-standard-profile-request public-profile-url related-profile-views mfeed-rss-url suggestions connections:(distance,id,first-name,last-name,headline,location,current-share,summary,specialties,associations,positions,phone-numbers,im-accounts,twitter-accounts,primary-twitter-account,main-address,picture-url,site-standard-profile-request))
  S3_CACHE_BUCKET = "#{ENV['S3_CACHE_BUCKET_PREFIX']}-#{Rails.env.to_s}"
  LINKEDIN_SCOPE = 'r_emailaddress r_contactinfo r_network r_fullprofile'


  def self.clean_string(file_contents)
    file_contents.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    file_contents.encode!('UTF-8', 'UTF-16')
    file_contents
  end

  
  def self.full_name(linkedin_id)
    full = profile(linkedin_id)
    return "#{full['first_name']} #{full['last_name']}"
  end
  
  def self.profile(linkedin_id, linkedin_oauth) 
    cache_key = "oauths/#{linkedin_oauth.id}/profiles/#{linkedin_id}.json"
    
    cache_value = S3Cache.fetch(cache_key, S3_CACHE_BUCKET)
    if cache_value
      return ActiveSupport::JSON.decode(cache_value)
    else
      begin
        result = linkedin_oauth.linkedin_access_token.profile(id: linkedin_id, fields: PROFILE_COLUMNS)
        S3Cache.write(cache_key, result.to_json, S3_CACHE_BUCKET)
      rescue
        result = { "first_name" => "Private", "last_name" => "Private" }
      end
      return result
    end
  end
  
  def self.me(linkedin_oauth) 
    cache_key = "oauths/#{linkedin_oauth.id}/me.json"
    
    cache_value = S3Cache.fetch(cache_key, S3_CACHE_BUCKET)
    if cache_value
      return ActiveSupport::JSON.decode(cache_value)
    else
      result = linkedin_oauth.linkedin_access_token.profile(fields: ME_COLUMNS)
      S3Cache.write(cache_key, result.to_json, S3_CACHE_BUCKET)
      return result
    end
  end
  
  def self.company_search(company_name, linkedin_oauth)
    max_results = 50
    cache_key = "oauths/#{linkedin_oauth.id}/company_search/#{clean_string(company_name)}.json"
    
    cache_value = S3Cache.fetch(cache_key, S3_CACHE_BUCKET)
    if cache_value
      return ActiveSupport::JSON.decode(cache_value)
    else
      per_page = 25
      start = 0
      collected_profiles = []

      # Loop until LinkedIn doesn't have anything to return
      new_profiles = [true]
      while !new_profiles.nil? && collected_profiles.length < max_results
        new_profiles = linkedin_oauth.linkedin_access_token.search(
        { 
          keywords: clean_string(company_name), 
          count: per_page, 
          start: start, 
          hq_only: 'true'
        }, 
        'company').companies.all
        
        unless new_profiles.nil?
          collected_profiles = collected_profiles.concat(new_profiles)
        end
        start = start + per_page
      end
      
      collected_profiles
    end
    S3Cache.write(cache_key, collected_profiles.to_json, S3_CACHE_BUCKET)
    return collected_profiles
  end
  
  def self.company_connections(company_name, linkedin_oauth)
    cache_key = "oauths/#{linkedin_oauth.id}/companies/#{clean_string(company_name)}.json"
    
    cache_value = S3Cache.fetch(cache_key, S3_CACHE_BUCKET)
    if cache_value
      return ActiveSupport::JSON.decode(cache_value)
    else
      per_page = 25
      start = 0
      collected_profiles = []

      # Loop until LinkedIn doesn't have anything to return
      new_profiles = [true]
      while !new_profiles.nil?
        new_profiles = linkedin_oauth.linkedin_access_token.search(
        { 
          company_name: clean_string(company_name), 
          count: per_page, 
          start: start, 
          sort: 'connections',
          fields: ["people:(#{SEARCH_COLUMNS.join(',')})"]
        },
        'people').people.all
        
        unless new_profiles.nil?
          collected_profiles = collected_profiles.concat(new_profiles)
        end
        start = start + per_page
      end
      
      collected_profiles
    end
    S3Cache.write(cache_key, collected_profiles.to_json, S3_CACHE_BUCKET)
    return collected_profiles
  end
  

end
