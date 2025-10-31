# ---------------------------
# This file seeds the database with default data.
# Run with: rails db:seed
# ---------------------------

puts "🧹 Cleaning database..."

# ⚡️ First, delete the dependent tables to respect foreign key constraints
# Use 'if defined?' to avoid errors if the model/table doesn't exist yet
Comment.destroy_all   if defined?(Comment)
Like.destroy_all      if defined?(Like)
Payment.destroy_all   if defined?(Payment)
Review.destroy_all    if defined?(Review)
Appointment.destroy_all if defined?(Appointment)
User.destroy_all      if defined?(User)

puts "✅ Database cleaned!"

# ---------------------------------
# 👑 Create Admin User (securely)
# ---------------------------------
admin_email = ENV["ADMIN_EMAIL"] || "admin@example.com"
admin_password = ENV["ADMIN_PASSWORD"] || "changeme123"

if defined?(User)
  # Only attempt to create the admin if the User model exists
  # This prevents the seed from breaking if the model is not yet created
  admin = User.find_or_create_by!(email: admin_email) do |user|
    user.password = admin_password
    user.password_confirmation = admin_password
    user.admin = true
  end
  puts "👑 Admin created: #{admin.email}"
  puts "⚠️ Password is taken from ENV or defaulted to 'changeme123' (change it in production!)"
end

# ---------------------------------
# 👤 Create Regular Users
# ---------------------------------
if defined?(User)
  # Only create users if the User model exists
  user1 = User.create!(email: "user1@example.com", password: "password123", password_confirmation: "password123")
  user2 = User.create!(email: "user2@example.com", password: "password123", password_confirmation: "password123")
  puts "👥 Regular users created!"
end

# ---------------------------------
# 📅 Create Appointments
# ---------------------------------
if defined?(Appointment) && defined?(User)
  # Only create appointments if Appointment and User models exist
  # This ensures the foreign key 'user_id' is valid
  appointment1 = Appointment.create!(
    user: user1,
    date: Date.today + 2,
    start_time: Time.now + 3.hours,
    description: "Initial consultation"
  )

  appointment2 = Appointment.create!(
    user: user2,
    date: Date.today + 4,
    start_time: Time.now + 5.hours,
    description: "Follow-up meeting"
  )

  puts "📅 Appointments created!"
end

# ---------------------------------
# 📝 Create Reviews
# ---------------------------------
if defined?(Review) && defined?(User)
  # Only create reviews if Review and User models exist
  # Reviews require a user_id foreign key
  review1 = Review.create!(
    user: user1,
    title: "Great service",
    content: "I loved it, very professional!",
    rating: 5
  )

  review2 = Review.create!(
    user: user2,
    title: "Good follow-up",
    content: "Some small delays but overall nice.",
    rating: 4
  )

  puts "📝 Reviews created!"
end

# ---------------------------------
# 💬 Create Comments
# ---------------------------------
if defined?(Comment) && defined?(User) && defined?(Review)
  # Only create comments if Comment, User, and Review models exist
  # This prevents foreign key errors on 'user_id' and 'review_id'
  Comment.create!(user: user2, review: review1, content: "I agree, top experience 😍")
  Comment.create!(user: user1, review: review2, content: "Thanks for your feedback 👍")
  puts "💬 Comments created!"
end

# ---------------------------------
# ❤️ Likes
# ---------------------------------
if defined?(Like) && defined?(User) && defined?(Review)
  # Only create likes if Like, User, and Review models exist
  # This ensures foreign keys are valid
  Like.create!(user: user1, review: review1)
  Like.create!(user: user2, review: review1)
  puts "❤️ Likes added!"
end

# ---------------------------------
# 💳 Payments
# ---------------------------------
if defined?(Payment) && defined?(User) && defined?(Appointment)
  # Only create payments if Payment, User, and Appointment models exist
  # Ensures 'user_id' and 'appointment_id' foreign keys are valid
  Payment.create!(user: user1, appointment: appointment1, amount_cents: 5000)
  Payment.create!(user: user2, appointment: appointment2, amount_cents: 5000)
  puts "💳 Payments created!"
end

# ---------------------------------
# ✅ Final message
# ---------------------------------
puts "🌱 Seeding complete!"
puts "👑 Admin: #{admin_email}"
puts "💡 Tip: Use ENV variables for credentials in production."
