CommonPlace.wire_item.TransactionWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/transaction-item"
  tagName: "li"
  className: "wire-item"

  events:
    "click .buy-link": "messageUser"
    "click .editlink": "editTransaction"
    "click .thank-link": "thank"
    "click .flag-link": "flag"
    "click .share-link": "share"
    "click .reply-link": "reply"
    "click .author": "showUserWire"
    "click .title": "showWireItem"
    blur: "removeFocus"

  price: ->
    @format @model.get("price")

  format: (cents) ->
    if cents is 0
      "Free"
    else
      "$" + (cents / 100.0).toFixed(2).toLocaleString()

  messageUser: (e) ->
    e.preventDefault()  if e
    params = { buyer: CommonPlace.account.id }
    $.post "/api" + @model.link("buy"), params, _.bind((response) ->
      subject = "Re: " + @model.get("title")
      _kmq.push(['record', 'Clicked Buy', {'Schema': @model.get("schema"), 'ID': @model.id, 'Price': @model.get("price")}]) if _kmq?
      @model.user (user) ->
        formview = new MessageFormView(model: new Message(messagable: user), subject: subject)
        formview.render()
    , this)

  canEdit: ->
    #CommonPlace.account.canEditTransaction @model
    false

  editTransaction: (e) ->
    e.preventDefault()
    formview = new CommonPlace.main.TransactionForm(
      model: @model
      template: "shared/transaction-edit-form"
    )
    formview.render()
)
