module TweetWatch
  
  class CLI < Thor
    include Client
          
    desc "limits", "Print out the current rate limits"
    def limits
      resp = client.get( "/1.1/application/rate_limit_status.json" )
      current_time = Time.now.to_i
      template = "   %-40s %5d remaining, resets in %3d seconds\n"
      resp.body[:resources].each do |category,resources|
        puts category.to_s
        resources.each do |resource,info|
          printf template, resource.to_s, info[:remaining], info[:reset] - current_time
        end
      end
    end
    
  end
  
end