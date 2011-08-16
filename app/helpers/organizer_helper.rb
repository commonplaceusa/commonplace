module OrganizerHelper
  def google_maps_api_key
    [
      'ABQIAAAAgdPfd74v_0Ttup6W0tJHtxRNtGYSdxHAX2hqsWz4YGYENJAGdhSzZ0AeIOf9BGJ4oPgPhrzNInJrQQ',
      'ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA'
    ].shuffle.first
end
