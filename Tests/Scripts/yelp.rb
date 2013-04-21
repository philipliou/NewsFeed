def serialize_yelp(yelp)

 y = Yelp.find_or_initialize_by_yelp_pid(yelp['id'])

 y.yelp_pid = yelp['id']

 y.name = yelp['name'].nil? ? nil : yelp['name']

 y.phone = yelp['phone'].nil? ? nil : yelp['phone']

 y.review_count = yelp['review_count'].nil? ? nil : yelp['review_count']

 y.street = yelp['location']['address'].nil? ? nil :
yelp['location']['address']

 y.city = yelp['location']['city'].nil? ? nil : yelp['location']['city']

 y.state = yelp['location']['state_code'].nil? ? nil :
yelp['location']['state_code']

 y.country = yelp['location']['country_code'].nil? ? nil :
yelp['location']['country_code']

 y.zip = yelp['location']['postal_code'].nil? ? nil :
yelp['location']['postal_code']

 y.lat = yelp['location']['coordinate']['latitude'].nil? ? nil :
yelp['location']['coordinate']['latitude']

 y.lng = yelp['location']['coordinate']['longitude'].nil? ? nil :
yelp['location']['coordinate']['longitude']

 y.expires_at = Time.now + 1.days

 y.save

 if !yelp['review'].nil?

 yelp['reviews'].each do |review|

 r = YelpReview.find_or_initialize_by_yelp_review_pid(review['id'])

 r.yelp_review_pid = review['id']

 r.yelp_id = y.id

 r.excerpt = review['excerpt'].nil? ? nil : review['excerpt']

 r.rating = review['rating'].nil? ? nil : review['rating']

 r.time_created = Time.at(review['time_created'])

 r.user_name = review['user']['name'].nil? ? nil : review['user']['name']

 r.user_id = review['user']['id'].nil? ? nil : review['user']['id']

 r.save

 end

 end

 return y

 end
