class ChargesController < ApplicationController

  def new
  end

  def create
    #amount in cents
    @amount = 500

    customer = Stripe::Customer.create(
      :email => 'example@stripe.com',
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Donation to Clipped.io',
      :currency    => 'usd'
    )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
  end

end
