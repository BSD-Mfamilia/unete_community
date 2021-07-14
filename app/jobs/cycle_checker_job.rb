class CycleCheckerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    User.find_each do |user|
      last_donation = user.donations.find_by(complete_cycle: false)
      guests = user.guests.where(sponsor: false, complete_cycle: false, cycle: last_donation.cycle) if last_donation

      if guests && guests.count >= 6
        new_cycle = last_donation.cycle
        new_cycle += 1
  
        new_donation = Donation.new(amount: last_donation.amount, invited_by: last_donation.invited_by, cycle: new_cycle, campaign: last_donation.campaign, user: user, sponsor: last_donation.sponsor)

        if new_donation.save
          last_donation.update(complete_cycle: true)
        end
      end

      if guests && guests.count >= 2
        quantity = 0
        new_cycle = last_donation.cycle
        new_cycle += 1
        guests.each do |guest|
          indirect_quantity = guest.user.guests.where(sponsor: false, complete_cycle: false, cycle: last_donation.cycle).count
          if indirect_quantity >= 2
            quantity += 1
          end
        end
        if quantity >= 2
          new_donation = Donation.new(amount: last_donation.amount, invited_by: last_donation.invited_by, cycle: new_cycle, campaign: last_donation.campaign, user: user, sponsor: last_donation.sponsor)

          if new_donation.save
            last_donation.update(complete_cycle: true)
          end
        end
      end

    end
  end
end
