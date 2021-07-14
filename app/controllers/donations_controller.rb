class DonationsController < ApplicationController
  before_action :set_campaign
  before_action :set_donation, only: %i[ show edit update destroy ]

  # GET /donations/new
  def new
    # @donation = Donation.new
    @donation = @campaign.donations.build
  end

  # POST /donations or /donations.json
  def create
    @donation = @campaign.donations.build(donation_params)
    @donation.user = current_user
    @donation.amount = @campaign.donations.find_by(sponsor: true).try(:amount)

    respond_to do |format|
      if @donation.save
        format.html { redirect_to root_path, notice: "Donation was successfully created." }
        format.json { render :show, status: :created, location: @donation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = @campaign.donations.find(params[:id])
    end

    def set_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    # Only allow a list of trusted parameters through.
    def donation_params
      params.require(:donation).permit(:amount, :invited_by, :cycle, :campaign_id, :user_id)
    end
end
