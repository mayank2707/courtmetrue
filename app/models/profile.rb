class Profile < ActiveRecord::Base
  belongs_to :user

  has_many :profile_photos
  has_many :profile_courtship_preferences
  has_many :courtship_preferences, through: :profile_courtship_preferences

  accepts_nested_attributes_for :profile_photos, :allow_destroy => true, :reject_if => :all_blank

  def male?
    self.gender == "Male"
  end

  def female?
    self.gender == "Female"
  end

  def finish_basic_info?
    if  self.name.blank? || self.age.blank? || self.dob.blank? ||
        self.country.blank? || self.state.blank? || self.city.blank? ||
        self.gender.blank? || self.status.blank? || self.religion.blank? ||
        self.language.blank? || self.tandc.blank?
      false
    else
      true
    end
  end

  def finish_personal_info?
    if  self.ethnicity.blank? || self.occupation.blank? ||
        self.income.blank? || self.household.blank? ||
        self.height.blank? || self.weight.blank? ||
        self.bodytype.blank? || self.smoker.blank? ||
        self.drinker.blank? || self.children.blank? ||
        self.wantkids.blank? || self.education.blank?
      false
    else
      true
    end
  end

  def finish_additional_info?
    completed = false
    unless self.profile_heading.blank? || self.selfbio.blank? ||
        self.ideal.blank?
      completed = true
      if self.expectations.blank?
        completed = false if self.male?
      end
    end
    completed
  end

  def has_uploaded_5_pics?
    self.profile_photos.count < 6
  end

  def first_photo?
    self.profile_photos.count == 0
  end

  def finished_profile?
    return finish_basic_info? && finish_personal_info? && finish_additional_info? ? true : false
  end

  def profile_pic
    self.profile_photos.first.try(:photo).try(:url, :thumb)
  end

  def address
    "#{city} #{country}"
  end
end
