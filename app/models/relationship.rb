class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :leader, class_name: "User"

  validate :unique_relationship, :two_person_relationship

  def unique_relationship
    if !!Relationship.find_by(leader: leader, follower: follower)
      errors.add(:you_are_already_following, leader.full_name)
    end
  end

  def two_person_relationship
    if leader == follower
      errors.add(:you_cannot_follow_yourself, follower.full_name)
    end
  end

end