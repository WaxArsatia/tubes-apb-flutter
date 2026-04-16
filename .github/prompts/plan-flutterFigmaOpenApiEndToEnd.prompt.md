# Plan: Flutter Figma + OpenAPI End-to-End

Confidence level is now about 96% based on your interview answers.

This plan delivers all referenced Figma screens with full API integration, strict typed models, high visual fidelity, and fast-delivery DX. Implementation is sequenced by your preferred milestones: Auth -> Dashboard -> Settings.

## Steps

1. Phase 0: Foundation and delivery acceleration.
2. Replace the starter app entrypoint and establish a scalable app skeleton with provider scope, router integration, and feature-first module boundaries.
3. Add runtime/tooling dependencies for Riverpod, go_router, Dio, secure token storage, model codegen, image upload/compression, and practical dev tooling.
4. Define shared design primitives from Figma tokens (colors, typography, spacing, input/button styles) plus reusable widgets used across all screens.
5. Configure dev-first environment setup targeting Android emulator backend at http://10.0.2.2:3000, structured so staging/prod can be added later.
6. Build networking core: typed client, auth header injection, refresh flow hook, and standardized error parsing for field-level + global UI errors.
7. Build auth session core: access token in memory, refresh token in secure storage, startup restoration, refresh-token exchange, and logout invalidation.
8. Build guarded route tree using go_router for all required public/private screens and placeholder routes.
9. Phase 1: Auth milestone.
10. Implement strict typed models and repositories for register/login/refresh/logout/me/forgot/verify-otp/change-password (both unauthenticated POST and authenticated PATCH).
11. Implement Landing, Create Account, Login with high-fidelity UI, form validation, inline errors, and global snackbar feedback.
12. Implement Forgot Password, OTP, Change Password, Success flow with your rules:
13. Resend code triggers forgot-password again.
14. OTP timer comes from otpExpiresInMinutes and runs locally.
15. Success CTA goes to Dashboard only if authenticated; otherwise returns to public flow.
16. Wire settings security password change to authenticated PATCH endpoint.
17. Phase 2: Dashboard milestone.
18. Implement dashboard typed models/repository and map balance, budget remaining, income/expense, and recent transactions.
19. Implement Dashboard UI with high fidelity, including greeting/avatar, summary cards, transactions preview, and See all action.
20. Implement bottom navigation behavior:
21. Home active.
22. Budget and Saving open Coming Soon placeholder pages.
23. See all opens placeholder transaction history page.
24. Phase 3: Settings milestone.
25. Implement Profile (Setting) screen layout and interaction model to match Figma.
26. Implement personal info update with first name, last name, profile picture upload, and read-only email from me/profile source.
27. Implement client-side image constraints: jpg/png/webp, max 2MB, compression prompt when oversized.
28. Implement local-only currency and notification preferences with local persistence.
29. Implement logout flow from settings with session cleanup and guarded-route reset.
30. Phase 4: Validation and handoff quality.
31. Add minimal but strategic V1 tests (auth/session unit coverage + smoke widget tests for major routes/screens).
32. Update developer docs and runbook with setup, env usage, codegen, analyze/test commands, and milestone checklist.
33. Run manual end-to-end QA aligned to milestones: Auth complete, Dashboard complete, Settings complete.

## Relevant files

- lib/main.dart - replace starter scaffold with app bootstrap.
- pubspec.yaml - add dependencies and dev dependencies.
- analysis_options.yaml - tighten lint profile for maintainability.
- README.md - add DX runbook and project usage.
- android/app/build.gradle.kts - dev flavor/env-ready configuration.
- docs/openapi_spec.json - strict API contract source for typed models.
- docs/figma_url.txt - screen fidelity reference source.
- New modules will be added under lib/app, lib/core, lib/shared, lib/features/auth, lib/features/dashboard, and lib/features/settings.

## Verification

1. Run dependency setup and codegen generation steps.
2. Run static checks and ensure no analyzer errors.
3. Run automated tests (minimal V1 suite: auth/session unit + smoke widgets).
4. Manually verify all critical backend outcomes:
5. Register success/conflict/validation.
6. Login/session restore/guard redirect.
7. Forgot password, OTP verification, resend, and timer behavior.
8. Password reset success flow routing.
9. Authenticated password change from settings.
10. Dashboard data rendering and placeholder routes.
11. Profile multipart upload including size/type error handling.
12. Logout invalidation and route reset.

## Decisions captured from interview

- Full scope enabled: all listed screens + all relevant APIs + auth lifecycle + profile upload.
- Riverpod + go_router chosen.
- High Figma fidelity chosen.
- English copy chosen.
- Strict typed OpenAPI mapping chosen.
- Refresh token in secure storage and access token in memory chosen.
- Fastest delivery prioritized, with minimal strategic tests for V1.
- Dev-first backend target: http://10.0.2.2:3000.

If you want adjustments, tell me what to change and I will update the plan immediately.
If approved, use your handoff flow and I will execute this plan in implementation mode milestone-by-milestone.
