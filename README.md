# Clerk Authentication PoC — Rails 8

A minimal Ruby on Rails application demonstrating how to integrate [Clerk](https://clerk.com) authentication. This PoC focuses on the three core authentication flows: **Sign Up**, **Sign In**, and most importantly, **Sign Out**.

No database is used — Clerk manages all user data and sessions on its side, so nothing is persisted locally.

---

## 📋 Overview

This project is a proof of concept to understand how Clerk works with a Rails 8 app. It consists of:

- A single demo page visible only after successful login
- A working sign-out flow (the main focus of this PoC)
- No local user model, no database, no migrations

Clerk handles user management through its hosted UI, while the Rails app verifies the session token issued by Clerk.

---

## 🧰 Tech Stack

| Component | Version |
|-----------|---------|
| Ruby      | 3.3.9   |
| Rails     | 8.1.4   |
| Clerk SDK | `clerk-sdk-ruby` |
| Database  | _None_ (Active Record skipped) |

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/asifsaif1234/clerk_poc.git
cd clerk_poc
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Add Clerk credentials

This app was generated without Active Record, so configuration lives in Rails credentials. Open the encrypted credentials file:

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

Add the following block:

```yaml
clerk:
  secret_key: sk_test_xxxxxxxxxxxxxxxxxxxx
  publishable_key: pk_test_xxxxxxxxxxxxxxxx
  sign_in_url: https://your-app.clerk.accounts.dev/sign-in
  sign_up_url: https://your-app.clerk.accounts.dev/sign-up
```

> 🔐 The `secret_key` must never be committed to Git. Rails credentials are encrypted and safe to commit; the `master.key` file is **not** — make sure it's in `.gitignore`.

You can grab your keys from the Clerk Dashboard under **API Keys**.

### 4. Start the server

```bash
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000).

---

## 🔐 Authentication Flow

```
┌──────────────┐      ┌─────────────────┐      ┌──────────────────┐
│  Unauthed    │─────▶│  Clerk Sign In  │─────▶│   Demo Page      │
│  User        │      │  (hosted UI)    │      │   (protected)    │
└──────────────┘      └─────────────────┘      └──────────────────┘
                                                        │
                                                        ▼
                                                 ┌──────────────┐
                                                 │  Sign Out    │
                                                 └──────────────┘
```

1. **Sign Up / Sign In** — When an unauthenticated user hits the demo page, they're redirected to Clerk's hosted sign-in page. After successful auth, Clerk redirects them back to the app with a valid session.
2. **Authenticated View** — The demo page checks `clerk_user_signed_in?`. If true, it renders and shows the user's email and ID from Clerk.
3. **Sign Out** — Clicking the sign-out button destroys the session locally and invalidates it with Clerk, returning the user to a signed-out state.

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| `config/credentials.yml.enc` | Stores Clerk API keys securely |
| `config/initializers/clerk.rb` | Initializes the Clerk SDK with credentials |
| `app/controllers/application_controller.rb` | Includes `Clerk::Authenticatable` |
| `app/controllers/demo_controller.rb` | Protected controller with `before_action` guard |
| `app/views/demo/index.html.erb` | Demo page with user info + sign-out button |
| `config/routes.rb` | Root route pointing to the demo page |

---

## 🧪 What This PoC Tests

- ✅ Successful Sign In via Clerk's hosted UI
- ✅ Successful Sign Up via Clerk's hosted UI
- ✅ Session persistence across requests
- ✅ Protected route redirects unauthenticated users
- ✅ Working Sign Out that clears the session
- ✅ No database required

---

## ⚠️ Notes & Caveats

- **No database**: This app was generated with `--skip-active-record`. There is no `database.yml`, no migrations, and no models. If you later need persistence (e.g., syncing Clerk users to your own DB via webhooks), regenerate or add Active Record back.
- **Test keys**: The `sk_test_` / `pk_test_` prefixes indicate Clerk **development** keys. Swap for `sk_live_` / `pk_live_` before deploying.
- **No user table**: User data is read directly from the Clerk session. If you need a `current_user` backed by a local record, you'd add webhook syncing.
- **Environment**: This PoC was built and tested on Ruby 3.3.9 with Rails 8.1.4.

---

## 🛠 Troubleshooting

| Symptom | Fix |
|---------|-----|
| Redirect loop on the demo page | Ensure `sign_in_url` in credentials points to Clerk's hosted page, not your own root |
| `Clerk::ConfigurationError` | Verify `clerk.secret_key` exists in credentials and the initializer reads it correctly |
| Sign-out button does nothing | Confirm `clerk_sign_out_url` is available or use the custom `DELETE /sign_out` route |
| `uninitialized constant Clerk` | Run `bundle install` and restart the server |

---

## 📚 References

- [Clerk Documentation](https://clerk.com/docs)
- [clerk-sdk-ruby on GitHub](https://github.com/clerk/clerk-sdk-ruby)
- [Rails 8 Release Notes](https://rubyonrails.org/)

---

## 📄 License

This is a personal proof of concept. Feel free to copy, modify, and learn from it.