Factory.define :podcast_subscription do |ps|
  ps.url 'http://podkast.nrk.no/program/kometkameratene.rss'
  ps.title 'NRK – Kometkameratene'
  ps.image 'http://www.nrk.no/img/623988.gif'
  ps.description 'Seks romvesener lander på jorda for å finne ut alt hva barn holder på med. Last ned sesong 2 gratis.'
end

Factory.define :podcast do |p|
  p.url 'http://podkast.nrk.no/fil/kometkameratene/nrk_kometkameratene_2009-1027-0159_40175.mp4?stat=1&amp;pks=40175'
  p.mime 'video/mp4'
  p.duration '00:34:00'
  p.guid 'nrk.no-poddkast-17168-40175-27.10.2009+13%3a59%3a00'
end
