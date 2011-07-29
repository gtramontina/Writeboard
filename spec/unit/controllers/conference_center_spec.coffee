CONFERENCE_CENTER = '../../../lib/controllers/conference_center'

describe 'Conference Center controller', ->

  conferenceCenter = n00p
  foundation = n00p
  doorman = n00p

  beforeEach ->
    foundation  = _
    doorman = stubWith 'doorman', ['leadPersonToRoom']
    conferenceCenter = require(CONFERENCE_CENTER) foundation, doorman

  it 'should provide foundation to the conference center', ->
    expect(conferenceCenter).toBe foundation

  it 'should allow people to join conference rooms', ->
    cb_hereYouGo = stub 'hereYouGo-callback'
    conferenceCenter.join {room: '13', personalInfo: id: '00-123'}, cb_hereYouGo
    doorman.leadPersonToRoom.should_have_been_called_with id: '00-123', '13'
    cb_hereYouGo.should_have_been_called()