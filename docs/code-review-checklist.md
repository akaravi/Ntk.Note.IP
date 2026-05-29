# Code Review Checklist — IPNote.ir

## Architecture

- [ ] Business logic in Application layer, not in endpoints/controllers
- [ ] Security/tenant context passed as last parameter where applicable
- [ ] Entity endpoints grouped by aggregate; Action* for operations, GetOne/GetList/Add/Update for CRUD

## API Contract

- [ ] Uniform result envelope (`isSuccess`, message, payload)
- [ ] Homogeneous lists in `data` array (no redundant `items` wrapper)
- [ ] OpenAPI updated; linked clients noted in PR description

## Quality

- [ ] Build and tests pass locally
- [ ] No secrets committed; use User Secrets / Key Vault
- [ ] Nullable reference types respected; no empty catch blocks

## i18n & UX

- [ ] User-visible strings use translation keys (fa base, en aligned)
- [ ] Theme tokens for light and dark; responsive layout checked
- [ ] RTL/LTR verified for Persian content

## Process

- [ ] `readmehistory.md` updated with date/time
- [ ] Relevant ADR or plan Result block updated if architecture changed
