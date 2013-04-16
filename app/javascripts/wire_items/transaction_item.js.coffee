CommonPlace.wire_item.TransactionWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/transaction-item"
  tagName: "li"
  className: "wire-item"
  tabName: "transaction"

  events:
    "click .wire_filter": "loadWire"
    "click .buy-link": "buyItem"
    "click .message-link": "messageUser"
    "click .editlink": "edit"
    "click .thank-link": "thank"
    "click .flag-link": "flag"
    "click .share-link": "share"
    "click .reply-link": "reply"
    "click .author": "showAuthorWire"
    "click .title": "showWireItem"

  price: ->
    @format @model.get("price")

  format: (cents) ->
    if cents is 0
      "Free"
    else
      "$" + (cents / 100.0).toFixed(2).toLocaleString()

  buyItem: (e) ->
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
    CommonPlace.account.canEditTransaction @model

)
