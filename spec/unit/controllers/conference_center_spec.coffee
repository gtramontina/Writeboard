CONFERENCE_CENTER = '../../../lib/controllers/conference_center'

describe 'Conference Center controller', ->

  conferenceCenter = n00p
  foundation = n00p
  doorman = n00p

  beforeEach ->
    foundation  = user: clientId: '00-12'
    doorman = stubWith 'doorman', ['leadPersonToRoom']
    conferenceCenter = require(CONFERENCE_CENTER) foundation, doorman

  it 'should provide foundation to the conference center', ->
    expect(conferenceCenter).toBe foundation

  it 'should allow people to join conference rooms', ->
    hereYouGo = stub 'hereYouGo-callback'
    conferenceCenter.join {roomNumber: '13'}, hereYouGo
    doorman.leadPersonToRoom.should_have_been_called_with '00-12', '13'
    hereYouGo.should_have_been_called()