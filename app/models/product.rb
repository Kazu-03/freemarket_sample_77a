class Product < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :product_images, dependent: :destroy
  has_many :favorites
  has_many :users, through: :favorites
  # belongs_to :user, dependent: :destroy
  belongs_to :brand, optional: true
  belongs_to :category
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, class_name: "User", optional: true
  
  # product.rbとproduct_image.rbに保存・更新・削除（allow_destroy: true）を同時にさせる
  accepts_nested_attributes_for :product_images, allow_destroy: true

  validates :name,                                 presence: true,  length:       { maximum: 40 }
  validates :profile,                              presence: true,  length:       { maximum: 1000 }
  validates :price,                                presence: true,  numericality: { greater_than_or_equal_to: 300}
  validates :category_id,                          presence: true
  validates :condition_id,                         presence: true
  validates :postage_id,                           presence: true
  validates :prefecture_code_id,                   presence: true
  validates :sendingtype_id,                       presence: true
  validates_associated :product_images
  validates :product_images,                       presence: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :size
  belongs_to_active_hash :condition
  belongs_to_active_hash :sendingday
  belongs_to_active_hash :postage
  belongs_to_active_hash :sendingtype
  belongs_to_active_hash :prefecture_code

  def favorite_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  # whereメソッドで検索対象となるカラムの取得
  def self.search(search)
    if search
      Product.where('name LIKE(?)', "%#{search}%")
    else
      Product.all
    end
  end
end
