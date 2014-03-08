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

  getBetAmount = ->
    parseInt($(".bet-group :radio:checked").val())
  
  getRowNumber = -> 
    parseInt($(".line-group :radio:checked").val())

  $("#createGameForm").submit (e) ->
    e.preventDefault()
    $("#createGameForm").find(":submit").attr("disabled", true)

    $.ajax {
      type: "POST",
      url: $(this).attr("action"),
      data: $(this).serialize(),
      dataType: "json",
      success: (jsonObject) ->
        reduceBalance(getBetAmount() * getRowNumber())
        spinAllReels(jsonObject.data.rotation_offsets)
        setUpdateBalancePromise(jsonObject.data.balance, jsonObject.data.win_amount)
      error: (jqXHR) ->
        alert(jqXHR.responseJSON.message)
        $("#createGameForm").find(":submit").attr("disabled", false)
    }

  setUpdateBalancePromise = (balance, win_amount) ->
    $(".left-reel, .middle-reel, .right-reel").promise().done ->
      updateBalance(balance)
      highlightBalance() if win_amount > 0

      $("#winAmount").text(win_amount)
      $("#createGameForm").find(":submit").attr("disabled", false)

  reduceBalance = (amount) ->
    precision = $("#balance").text().split(".")[1].length
    precision = 8 if precision > 8
    currentBalance = parseFloat($("#balance").text())
    updateBalance((currentBalance - amount).toFixed(precision))

  updateBalance = (balance) ->
    $("#balance").text(balance)

  highlightBalance = ->
    $("#balance").parent().css("color", "#FFF")
    $("#balance").parent().animate({
      'color': "#999"
    }, 450)

  updateUsername = (username) ->
    $("#usernameLink").text(username)


  $("#depositLink").click ->
    $("#depositModal").modal('show')

  $("#usernameLink").click ->
    $("#usernameModal").modal('show')

  $("#withdrawalLink").click ->
    $("#withdrawalModal").modal('show')

  $("#paytableLink").click ->
    $("#paytableModal").modal('show')

  $("#promotionLink").click ->
    $("#promotionModal").modal('show')

  prependAlertToModal = (modalSelector, message) ->
    dismissAlertBox(modalSelector)
    $(modalSelector).find(".modal-body").prepend("
      <div class='alert alert-danger alert-dismissable'>
        <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>
        #{message}
      </div>
    ")

  dismissAlertBox = (modalSelector) ->
    $(modalSelector).find(".alert.alert-danger.alert-dismissable").remove();

  $("#createPromotionRedemptionForm").submit (e) ->
    e.preventDefault()

    $.ajax {
      type: "POST",
      url: jQuery(this).attr("action"),
      data: jQuery(this).serialize()
      dataType: "json",
      success: (jsonObject) ->
        updateBalance(jsonObject.data.balance)
        highlightBalance()
        $("#promotionModal").modal('hide')
        dismissAlertBox("#promotionModal")
      error: (jqXHR) ->
        prependAlertToModal("#promotionModal", jqXHR.responseJSON.message)
    }

  $("#updateUsernameForm").submit (e) ->
    e.preventDefault()

    $.ajax {
      type: "PUT",
      url: jQuery(this).attr("action"),
      data: jQuery(this).serialize()
      dataType: "json",
      success: (jsonObject) ->
        updateUsername(jsonObject.data.username)
        $("#usernameModal").modal('hide')
        dismissAlertBox("#usernameModal")
      error: (jqXHR) ->
        prependAlertToModal("#usernameModal", jqXHR.responseJSON.message)
    }

  $("#createWithdrawalForm").submit (e) ->
    e.preventDefault()

    $.ajax {
      type: "POST",
      url: jQuery(this).attr("action"),
      data: jQuery(this).serialize()
      dataType: "json",
      success: (jsonObject) ->
        updateBalance(jsonObject.data.balance)
        $("#withdrawalModal").modal('hide')
        dismissAlertBox("#withdrawalModal")
      error: (jqXHR) ->
        prependAlertToModal("#withdrawalModal", jqXHR.responseJSON.message)
    }

  updateTotalBet = ->
    totalBet = getBetAmount() * getRowNumber()
    $("#totalBet").text(totalBet)

  $(".bet-group :radio").click ->
    updateTotalBet()
    if $(this).closest(".btn").hasClass("active") == false
      $(this).closest(".bet-group").find(".active").removeClass("active")
      $(this).closest(".btn").addClass("active")

  $(".line-group :radio").click ->
    updateTotalBet()
    updateArrows()

    if $(this).closest(".btn").hasClass("active") == false
      $(this).closest(".line-group").find(".active").removeClass("active")
      $(this).closest(".btn").addClass("active")

  updateArrows = ->
    $(".arrow-container .row-arrow").removeClass("row-arrow-active")

    switch getRowNumber()
      when 1
        $(".arrow-container .row-arrow:nth-child(2)").addClass("row-arrow-active")
      when 2
        $(".arrow-container .row-arrow:nth-child(1)").addClass("row-arrow-active")
        $(".arrow-container .row-arrow:nth-child(3)").addClass("row-arrow-active")
      when 3
        $(".arrow-container .row-arrow").addClass("row-arrow-active")