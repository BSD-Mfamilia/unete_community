class Campaign < ApplicationRecord
  belongs_to :user
	has_many :donations, dependent: :destroy

  attribute :amount, :float, default: -> { 0.0 }

  validates :amount, inclusion: { in: [50.0, 100.0, 200.0, 300.0, 500.0, 1000.0], message: "%{value} is not a valid amount" }
  validates_presence_of :name, :description
  validates :name, uniqueness: true


  after_commit :create_sponsor, on: [:create]

  def create_sponsor
    donation = self.donations.build(amount: self.amount, invited_by: self.user.email, user: self.user, sponsor: true)
    donation.save
  end
end
