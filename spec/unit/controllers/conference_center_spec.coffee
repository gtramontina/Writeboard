CONFERENCE_CENTER = '../../../lib/controllers/conference_center'

describe 'Conference Center controller', ->

  conferenceCenter = n00p
  foundationDouble = n00p
  doorman = n00p
  fakeWorkspaceInfo = _

  beforeEach ->
    foundationDouble = user: clientId: 'fake person id'
    doorman = stubWith 'doorman', ['leadPersonToRoom', 'giveMeRoomInfo']
    doorman.giveMeRoomInfo.andCallFake -> 'fake room info'
    fakeWorkspaceInfo = roomNumber: 'fake room number'
    conferenceCenter = require(CONFERENCE_CENTER) foundationDouble, doorman

  it 'should provide foundation to the conference center', ->
    expect(conferenceCenter).toBe foundationDouble

  it 'should allow people to join conference rooms', ->
    conferenceCenter.join fakeWorkspaceInfo, n00p
    doorman.leadPersonToRoom.should_have_been_called_with 'fake person id', fakeWorkspaceInfo

  it 'should provide the person who just joined with info about the room', ->
    hereYouGo = stub 'hereYouGo-callback'
    conferenceCenter.join fakeWorkspaceInfo, hereYouGo
    doorman.giveMeRoomInfo.should_have_been_called_with 'fake room number'
    hereYouGo.should_have_been_called_with 'fake room info'