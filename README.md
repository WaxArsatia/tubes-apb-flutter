# FinU Flutter App (Auth + Dashboard + Settings)

Flutter client implementation for FinU, aligned to:

- Figma screens in `docs/figma_url.txt`
- OpenAPI contract in `docs/openapi_spec.json`

This V1 includes:

- Auth flows: register, login, forgot password, OTP verify, change password
- Session lifecycle: startup restore, refresh token exchange, logout cleanup
- Dashboard summary + recent transactions preview
- Settings: profile update (multipart upload), security password update, local preferences
- Placeholder pages for Budget, Saving, and Transaction History

## Stack

- State management: `flutter_riverpod`
- Routing: `go_router`
- HTTP client: `dio`
- Secure storage: `flutter_secure_storage`
- Local preferences: `shared_preferences`
- Typed models: `json_serializable` + `build_runner`
- Image upload/compression: `image_picker`, `flutter_image_compress`

## Project Structure

```text
lib/
	app/
		app.dart
		router/
	core/
		config/
		error/
		network/
		session/
		utils/
	shared/
		theme/
		widgets/
	features/
		auth/
		dashboard/
		settings/
```

## Environment Setup

Default dev backend target is platform-aware:

- Android emulator: `http://10.0.2.2:3000`
- iOS simulator: `http://127.0.0.1:3000`
- Desktop/Web: `http://localhost:3000`

`lib/core/config/app_env.dart` resolves base URL in this order:

1. `--dart-define=API_BASE_URL=...`
2. `APP_ENV` fallback (`dev`, `staging`, `prod`)

### Run (Dev)

Default flavor is configured as `dev`, so this works directly:

```bash
flutter run
```

Explicit command (equivalent):

```bash
flutter run --flavor dev \
	--dart-define=APP_ENV=dev \
	--dart-define=API_BASE_URL=http://10.0.2.2:3000
```

### Run (Staging)

```bash
flutter run --flavor staging \
	--dart-define=APP_ENV=staging \
	--dart-define=API_BASE_URL=https://your-staging-host
```

### Run (Prod)

```bash
flutter run --flavor prod \
	--dart-define=APP_ENV=prod \
	--dart-define=API_BASE_URL=https://your-production-host
```

## Setup Commands

Install dependencies:

```bash
flutter pub get
```

Generate typed model code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Quality Commands

Static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

## V1 Test Coverage

- Unit: `test/core/session/auth_session_controller_test.dart`
- Widget smoke: `test/widget_test.dart`

## Milestone Checklist

### Auth

- [x] Register success + validation handling
- [x] Login + session establishment
- [x] Startup session restoration via refresh token
- [x] Forgot password endpoint integration
- [x] OTP verification + local timer based on `otpExpiresInMinutes`
- [x] Resend OTP via forgot-password endpoint
- [x] Unauthenticated change-password endpoint integration
- [x] Success CTA routes to dashboard only if authenticated

### Dashboard

- [x] Typed dashboard models + repository
- [x] Balance, budget remaining, income/expense cards
- [x] Recent transactions preview
- [x] Bottom nav shell
- [x] Budget, Saving, and See all routes as placeholders

### Settings

- [x] Profile/setting layout
- [x] Profile patch endpoint (`/settings/profile`) with multipart upload
- [x] Client constraints: jpg/png/webp, max 2MB, compression prompt
- [x] Security password change via authenticated PATCH endpoint
- [x] Local currency preference persistence
- [x] Local notification preference persistence
- [x] Logout with local invalidation + guarded route reset

## Manual QA Runbook

1. Register new account and verify success/validation errors.
2. Login and verify guarded navigation reaches dashboard.
3. Restart app and verify restored session from stored refresh token.
4. Execute forgot-password flow, verify OTP timer and resend behavior.
5. Complete password reset and confirm success routing.
6. Change password from Settings > Security using authenticated endpoint.
7. Verify dashboard data rendering from backend.
8. Update profile with valid and invalid image files (type/size checks).
9. Toggle local preferences and verify persistence after restart.
10. Log out and confirm private routes redirect to auth flow.
