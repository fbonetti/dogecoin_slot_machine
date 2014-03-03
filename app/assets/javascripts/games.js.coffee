$ ->
  REEL_IMAGE_HEIGHT = 3000
  SINGLE_IMAGE_HEIGHT = 150

  spinAllReels = (rotationOffsets) ->
    spinSingleReel(0, rotationOffsets.left_reel)
    spinSingleReel(1, rotationOffsets.middle_reel)
    spinSingleReel(2, rotationOffsets.right_reel)

  spinSingleReel = (reelNumber, relativeTargetOffset) ->
    currentPosition = parseInt($(".reel:eq(#{reelNumber})").css("background-position-y"))
    roundedPosition = Math.ceil(currentPosition / REEL_IMAGE_HEIGHT) * REEL_IMAGE_HEIGHT
    targetOffset = roundedPosition + (randBetween(4, 7) * REEL_IMAGE_HEIGHT) - (relativeTargetOffset * SINGLE_IMAGE_HEIGHT)

    $(".reel:eq(#{reelNumber})").animate {
      'background-position-y': targetOffset,
      'easing': 'easeOutCubic'
    }, randBetween(1500, 3000)

  randBetween = (min, max) ->
    Math.round(Math.random() * (max - min) + min)

  $("[data-id=submit-bet]").click ->
    return null if $(this).attr("disabled")
    betAmount = parseInt($(".bet-group :radio:checked").val())

    $.ajax {
      type: "POST",
      url: "/games",
      data: {bet_amount: betAmount}
      dataType: "json",
      success: (jsonObject) ->
        $("[data-id=submit-bet]").attr("disabled", true)
        reduceBalance(betAmount)
        spinAllReels(jsonObject.data.rotation_offsets)
        setUpdateBalancePromise(jsonObject.data.balance, jsonObject.data.win_amount)
      error: (jqXHR) ->
        alert(jqXHR.responseJSON.message)
    }

  setUpdateBalancePromise = (balance, win_amount) ->
    $(".left-reel, .middle-reel, .right-reel").promise().done ->
      updateBalance(balance)
      $("[data-id=submit-bet]").attr("disabled", false)

      if win_amount > 0
        $("#balance").parent().css("color", "#FFF")
        $("#balance").parent().animate({"color": "#999", 900})


      # for i in [1..win_amount] by 1
      #   console.log 'ok'
      #   setTimeout((-> playSoundEffect("#dingSound")), i * 100)

  reduceBalance = (amount) ->
    currentBalance = parseInt($("#balance").text())
    updateBalance(currentBalance - amount)

  updateBalance = (balance) ->
    $("#balance").text(balance)

  updateUsername = (username) ->
    $("#usernameLink").text(username)


  $("#depositLink").click ->
    $("#depositModal").modal('show')

  $("#usernameLink").click ->
    $("#usernameModal").modal('show')

  $("#withdrawalLink").click ->
    $("#withdrawalModal").modal('show')

  $("#updateUsernameForm").submit (e) ->
    e.preventDefault()

    $.ajax {
      type: "PUT",
      url: jQuery(this).attr("action"),
      data: jQuery(this).serialize()
      dataType: "json",
      success: (jsonObject) ->
        updateUsername(jsonObject.data.username)
      error: (jqXHR) ->
        alert(jqXHR.responseJSON.message)
    }

    $("#usernameModal").modal('hide')

  $("#createWithdrawalForm").submit (e) ->
    e.preventDefault()

    $.ajax {
      type: "POST",
      url: jQuery(this).attr("action"),
      data: jQuery(this).serialize()
      dataType: "json",
      success: (jsonObject) ->
        updateBalance(jsonObject.data.balance)
      error: (jqXHR) ->
        alert(jqXHR.responseJSON.message)
    }

    $("#withdrawalModal").modal('hide')

  currentBet = 5

  $(".bet-group :radio").click ->
    if $(this).closest(".btn").hasClass("active") == false
      newBet = parseInt($(this).val())
      if newBet > currentBet
        playSoundEffect("#betUpSound")
      else
        playSoundEffect("#betDownSound")

      currentBet = newBet
      $(".bet-group .btn").removeClass("active")
      $(this).closest(".btn").addClass("active")

  playSoundEffect = (selector) ->
    # soundEffect = $(selector).clone().get(0)
    # soundEffect.volume = 0.5
    # soundEffect.play()