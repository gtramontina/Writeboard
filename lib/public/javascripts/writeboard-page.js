(function() {
  var WriteboardPage;
  WriteboardPage = function() {
    var closeTheDoor, dom, enableCanvas, messages, peopleWatching, rawCanvas, writeboard, _ref;
    humane.waitForMove = false;
    loading.setShowAnimation(function(element) {
      var _ref;
      _ref = [0, 'initial'], element.style.opacity = _ref[0], element.style.display = _ref[1];
      return emile(element, 'opacity:1');
    });
    loading.setHideAnimation(function(element) {
      return emile(element, 'opacity:0', {
        after: function() {
          return element.style.display = 'none';
        }
      });
    });
    peopleWatching = false;
    dom = {
      body: $('body'),
      canvas: $('#writeboard'),
      helpButton: $('#misc #help'),
      eye: $('#misc #eye'),
      lock: $('#misc #lock'),
      room: $('room'),
      markers: $('#toolbar #markers'),
      snapshot: $('#toolbar #snapshot')
    };
    messages = {
      loading: 'Loading. Please wait...',
      joining: 'Joining room...',
      joinedRoom: 'Someone joined the room',
      leftRoom: 'Someone left the room',
      biggerBoard: 'And a bigger board is required',
      setPassword: 'Enter a password:\n\nNOTE: there is no password encryption yet, so please do not use any of your personal passwords!',
      askPassword: 'This room is locked. Please enter the password to open it.',
      wrongPassword: 'Wrong password.',
      roomLocked: 'The room has been locked'
    };
    loading.show(messages.loading);
    rawCanvas = dom.canvas[0];
    _ref = [window.innerWidth, window.innerHeight], rawCanvas.width = _ref[0], rawCanvas.height = _ref[1];
    writeboard = createWriteboard(rawCanvas);
    now.takeSnapshot = function(callback) {
      return callback(writeboard.takeSnapshot());
    };
    now.updateUserCount = function(count) {
      if (peopleWatching) {
        humane(messages[peopleWatching < count ? 'joinedRoom' : 'leftRoom']);
      }
      return dom.eye.text(peopleWatching = count);
    };
    now.requirePassword = function(callback, wrong) {
      var password;
      if (wrong) {
        alert(messages.wrongPassword);
      }
      password = prompt(messages.askPassword);
      if (password) {
        return callback(password);
      } else {
        return window.location.replace('/');
      }
    };
    now.setColor = function(color) {
      var marker;
      dom.markers.children().removeClass('selected');
      marker = dom.markers.find("[data-color=" + color + "]");
      marker.addClass('selected');
      return writeboard.setColor(color);
    };
    dom.canvas.bind('selectstart', function() {
      return false;
    });
    dom.helpButton.click(function() {
      return $.get('/about', {
        noLayout: true
      }, function(aboutPage) {
        var about;
        about = $("" + aboutPage);
        about.hide();
        dom.body.append(about);
        return about.fadeIn();
      });
    });
    dom.lock.click(function() {
      var password;
      password = prompt(messages.setPassword);
      if (password) {
        return now.sendLockRoom(password);
      }
    });
    closeTheDoor = function(roomInfo) {
      var snapshot;
      writeboard.resize(roomInfo.size);
      now.setColor(roomInfo.markerColor);
      snapshot = roomInfo.snapshot;
      if (snapshot) {
        return writeboard.splash(snapshot, enableCanvas);
      } else {
        return enableCanvas();
      }
    };
    enableCanvas = function() {
      var drawing;
      now.startDrawing = function(x, y) {
        return writeboard.startDrawing(x, y);
      };
      now.draw = function(x, y) {
        return writeboard.draw(x, y);
      };
      now.stopDrawing = function() {
        return writeboard.stopDrawing();
      };
      now.resizeBoard = function(size) {
        humane(messages.biggerBoard);
        return writeboard.resize(size);
      };
      now.setRoomLocked = function() {
        humane(messages.roomLocked);
        dom.lock.removeClass('lock');
        return dom.lock.addClass('unlock');
      };
      dom.markers.click(function(e) {
        var color;
        color = $(e.target).attr('data-color');
        now.setColor(color);
        return now.sendSetColor(color);
      });
      dom.snapshot.click(function() {
        return now.takeSnapshot(function(image) {
          return window.open(image, '_blank');
        });
      });
      drawing = false;
      dom.canvas.mousedown(function(event) {
        var x, y, _ref2;
        drawing = true;
        _ref2 = [event.pageX, event.pageY], x = _ref2[0], y = _ref2[1];
        now.startDrawing(x, y);
        return now.sendStartDrawing(x, y);
      });
      dom.canvas.mousemove(function(event) {
        var x, y, _ref2;
        if (!drawing) {
          return;
        }
        _ref2 = [event.pageX, event.pageY], x = _ref2[0], y = _ref2[1];
        now.draw(x, y);
        return now.sendDraw(x, y);
      });
      dom.canvas.mouseup(function() {
        drawing = false;
        now.stopDrawing();
        return now.sendStopDrawing();
      });
      return loading.hide();
    };
    return {
      joinRoom: function() {
        var roomInfo;
        loading.show(messages.joining);
        roomInfo = {
          id: dom.room.attr('id'),
          markerColor: writeboard.getColor(),
          size: {
            width: rawCanvas.width,
            height: rawCanvas.height
          }
        };
        return now.joinRoom(roomInfo, closeTheDoor);
      }
    };
  };
  $(function() {
    var page;
    page = WriteboardPage();
    return now.ready(function() {
      return page.joinRoom();
    });
  });
}).call(this);
