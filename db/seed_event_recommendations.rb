feed = Feed.create(
  name: "new feed",
  about: "about",
  community_id: 1,
  slug: "new-feed-1",
avatar_file_name: "missing.png"
  )

3.times do |i|
  Event.create(
    name: "Event #{i}",
    description: "This is event #{i}'s description",
    date: DateTime.now,
    community_id: 1,
    owner: feed
    )
end 
