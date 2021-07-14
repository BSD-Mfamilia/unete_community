class Donation < ApplicationRecord
  belongs_to :campaign
  belongs_to :user
  belongs_to :invited, class_name: "User", primary_key: "email", foreign_key: "invited_by", validate: true

  validates :amount, inclusion: { in: [50.0, 100.0, 200.0, 300.0, 500.0, 1000.0], message: "%{value} is not a valid amount" }
  validates :user_id, uniqueness: { scope: :cycle }, on: :create
  validates :invited_by, presence: true

  validate :validate_invitation, on: :create
  validate :validate_number_of_direct_after_the_first_cycle, on: :create, if: -> { cycle >= 2 }

  scope :get_full_cycles_per_user, -> (campaign, user) { where(campaign: campaign, user: user, complete_cycle: true).count }

  def validate_invitation
    if self.sponsor == false && self.user.email == self.invited_by
      self.errors.add(:base, "Invalid invitation")
    end
  end

  def validate_number_of_direct_after_the_first_cycle
    number_of_direct = Donation.where(campaign: self.campaign, invited_by: self.invited_by, cycle: self.cycle, complete_cycle: false, sponsor: false).count

    if number_of_direct > 2
      self.errors.add(:base, "You can only have 2 direct")
    end
  end

end
