
This file lists the REST and WebSocket endpoints required for the mobile app, plus what each endpoint does.

## Base URL
- REST base: `BASE_URL` (backend origin). In dev, frontend config falls back to `http://localhost:8000`.
- All REST endpoints below are relative to `BASE_URL` and typically start with `/api/`.

## Auth
- JWT auth is used. Send header: `Authorization: Bearer <access_token>` when required.
- Tokens come from `/api/auth/login/` or `/api/auth/register/`.

---

## Auth & Account
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| POST | `/api/auth/login/` | No | Obtain JWT access/refresh tokens. |
| POST | `/api/auth/refresh/` | No | Refresh access token using refresh token. |
| POST | `/api/auth/register/` | No | Register a new user (supports individual/business). |
| POST | `/api/auth/validate/` | No | Validate username/email before registering. |
| POST | `/api/auth/logout/` | No | Blacklist refresh token (logout). |
| POST | `/api/auth/password-reset/request/` | No | Request password reset email. |
| POST | `/api/auth/password-reset/confirm/` | No | Confirm password reset with token. |
| POST | `/api/auth/password/change/` | Yes | Change password for authenticated user. |
| POST | `/api/auth/email/verify/` | No | Verify email using token. |

## User Profiles
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/auth/profile/<user_id>/` | No | Fetch a user's profile data. |
| POST | `/api/auth/profile/update/` | Yes | Update profile fields (bio, location, website, birth_date, cover_photo). |
| GET | `/api/auth/user/<user_id>/` | No | Fetch basic user data by id. |
| POST | `/api/auth/user/update/` | Yes | Update user fields (first_name, last_name, profile_picture). |
| GET | `/api/auth/user/username/<username>/` | No | Fetch user by username. |

## Business Profiles
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/auth/auth/business-profile/<user_id>/` | No | Fetch business profile for user. |
| POST | `/api/auth/auth/business-profile/update/` | Yes | Update business profile for current user. |

## Payments
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/auth/user/payment-status/` | Yes | Check membership/advertising payment status. |
| POST | `/api/auth/user/payment/record/` | Yes | Record a payment (membership/advertising). |
| POST | `/api/auth/payments/fortis/charge/` | Yes | Process Fortis payment and record it. |
| POST | `/api/auth/paypal/create-order/` | Yes | Create PayPal order and return approval URL. |
| GET | `/api/auth/paid-members/` | Yes | List paid members. |

## Social: Posts & Feed
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/posts/` | Yes | Fetch feed posts (supports `user_id`, `cursor`, `limit`). |
| POST | `/api/posts/create/` | Yes | Create a text-only post. |
| POST | `/api/create-post/` | Yes | Create post with serializer (supports media upload). |
| PATCH | `/api/posts/<post_id>/edit/` | Yes | Edit post (partial update). |
| DELETE | `/api/posts/<post_id>/` | Yes | Delete post owned by user. |
| POST | `/api/posts/<post_id>/like/` | Yes | Like/unlike a post. |
| POST | `/api/posts/<post_id>/repost/` | Yes | Repost a post. |
| POST | `/api/posts/<post_id>/track-view/` | Yes | Track a post view. |
| GET | `/api/posts/<post_id>/comments/` | Yes | List comments (supports `page`). |
| POST | `/api/posts/<post_id>/comments/add/` | Yes | Add a comment to a post. |
| GET | `/api/user/<user_id>/posts/` | Yes | Get posts by user id. |
| GET | `/api/posts/user/<user_id>/` | Yes | Same as above (duplicate route). |

## Social: Follows
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| POST | `/api/follow/<user_id>/` | Yes | Follow a user. |
| POST | `/api/unfollow/<user_id>/` | Yes | Unfollow a user. |
| GET | `/api/follow/status/<user_id>/` | Yes | Check follow status. |
| GET | `/api/followers/<user_id>/` | No | Get follower count. |
| GET | `/api/following/<user_id>/` | No | Get following count. |
| GET | `/api/profile/<user_id>/followers/count/` | Yes | Get follower count (auth version). |
| GET | `/api/profile/<user_id>/following/count/` | Yes | Get following count (auth version). |
| GET | `/api/profile/<user_id>/followers/` | Yes | Get follower list (usernames + profile picture). |
| GET | `/api/profile/<user_id>/following/` | Yes | Get following list (usernames + profile picture). |
| GET | `/api/following-ids/` | Yes | Get list of ids the current user follows. |

## Social: Messaging & Contacts
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/messages/` | Yes | Get messages received by current user. |
| POST | `/api/messages/send/` | Yes | Send a message (receiver_id, content). |
| GET | `/api/messages/history/` | Yes | Get chat history between user1 and user2 (query params). |
| GET | `/api/contacts/` | Yes | List contacts (users the current user follows). |
| GET | `/api/unread-contacts/` | Yes | List contacts with unread messages. |

## Social: Notifications & Search
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/notifications/` | Yes | List notifications for current user. |
| GET | `/api/search/` | Yes | Search users and posts (query param `q`). |
| GET | `/api/user/<username>/` | No | Get user by username plus photos/videos from posts. |

---

## Advertisers Directory
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/advertisers/categories/` | No | List advertiser categories. |
| GET | `/api/advertisers/cities/` | No | List cities that have advertisers. |
| GET | `/api/advertisers/` | No | List advertisers with filtering and search. |
| GET | `/api/advertisers/<slug>/` | No | Get advertiser details by slug. |
| POST | `/api/advertisers/create/` | Yes | Create a new advertiser. |
| POST | `/api/advertisers/track/click/` | No | Track advertiser click. |
| POST | `/api/advertisers/track/view/` | No | Track advertiser view. |
| GET | `/api/advertisers/search/suggestions/` | No | Search suggestions for advertisers. |
| GET | `/api/advertisers/stats/` | No | Advertiser stats. |

## Advertising (User Ads)
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/advertising/ads/` | Yes | List ads owned by current user. |
| POST | `/api/advertising/ads/` | Yes | Create ad (list/create endpoint). |
| GET | `/api/advertising/ads/<id>/` | Yes | Retrieve ad owned by current user. |
| PUT | `/api/advertising/ads/<id>/` | Yes | Update ad owned by current user. |
| PATCH | `/api/advertising/ads/<id>/` | Yes | Partial update ad owned by current user. |
| DELETE | `/api/advertising/ads/<id>/` | Yes | Delete ad owned by current user. |
| GET | `/api/advertising/ads/all/` | No | Public list of all ads. |
| GET | `/api/advertising/ads/public/` | No | Public list of all ads (alternate endpoint). |
| POST | `/api/advertising/ads/create/` | Yes | Create ad (credit-checked). |
| GET | `/api/advertising/user-ads/` | Yes | Get ads for current user. |
| POST | `/api/advertising/track/ad-view/` | No | Track ad view. |
| POST | `/api/advertising/track/ad-click/` | No | Track ad click. |
| GET | `/api/advertising/payment-details/` | Yes | Advertising payment details (credits). |
| GET | `/api/advertising/profile-payments/` | Yes | Current user profile + payment history. |
| GET | `/api/advertising/invoice/<payment_id>/` | Yes | Download payment invoice (PDF). |

---

## Sponsors (DRF ViewSet)
Base: `/api/sponsors/`
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/sponsors/` | No | List sponsors (supports filters/search/order). |
| POST | `/api/sponsors/` | Yes | Create sponsor. |
| GET | `/api/sponsors/<id>/` | No | Retrieve sponsor. |
| PUT | `/api/sponsors/<id>/` | Yes | Update sponsor. |
| PATCH | `/api/sponsors/<id>/` | Yes | Partial update sponsor. |
| DELETE | `/api/sponsors/<id>/` | Yes | Delete sponsor. |
| POST | `/api/sponsors/<id>/track_click/` | No | Track sponsor click. |
| POST | `/api/sponsors/<id>/track_view/` | No | Track sponsor view. |
| GET | `/api/sponsors/featured/` | No | List featured sponsors. |
| GET | `/api/sponsors/stats/` | No | Sponsor stats. |

## Writers (DRF ViewSet)
Base: `/api/writers/`
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/writers/` | No | List writers (filters/search/order). |
| POST | `/api/writers/` | Yes | Create writer. |
| GET | `/api/writers/<id>/` | No | Retrieve writer. |
| PUT | `/api/writers/<id>/` | Yes | Update writer. |
| PATCH | `/api/writers/<id>/` | Yes | Partial update writer. |
| DELETE | `/api/writers/<id>/` | Yes | Delete writer. |
| POST | `/api/writers/<id>/track_view/` | No | Track writer view. |
| POST | `/api/writers/<id>/track_click/` | No | Track writer click. |
| GET | `/api/writers/featured/` | No | List featured writers. |
| GET | `/api/writers/analytics/` | No | Writer analytics. |

## Podcasts (DRF ViewSet)
Base: `/api/podcasts/`
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/podcasts/` | No | List podcasts. |
| POST | `/api/podcasts/` | Yes | Create podcast (authenticated user). |
| GET | `/api/podcasts/<id>/` | No | Retrieve podcast. |
| PUT | `/api/podcasts/<id>/` | Yes | Update podcast (owner or staff). |
| PATCH | `/api/podcasts/<id>/` | Yes | Partial update podcast. |
| DELETE | `/api/podcasts/<id>/` | Yes | Delete podcast (owner or staff). |
| POST | `/api/podcasts/<id>/track_view/` | No | Track podcast view. |
| POST | `/api/podcasts/<id>/track_play/` | No | Track podcast play. |

---

## External Content
| Method | Path | Auth | Function |
| --- | --- | --- | --- |
| GET | `/api/external/tenor/` | Yes | Search Tenor GIFs (`q`, `limit`). |
| GET | `/api/external/news/` | No | Get news feed (`category`, `q`, `max`). |
| GET | `/api/external/videos/` | No | Search videos via RapidAPI (`q`, `maxResults`). |

---

## WebSocket Endpoints
| Protocol | Path | Auth | Function |
| --- | --- | --- | --- |
| WS | `/ws/chat/<room_name>/` | Yes | Chat room websocket. |
| WS | `/chat/<room_name>/` | Yes | Chat room websocket (alternate). |
| WS | `/ws/notifications/` | Yes | Notifications websocket. |
| WS | `/notifications/` | Yes | Notifications websocket (alternate). |

---

## Media URLs
- Media files (profile pictures, post images/videos) are served under `/media/` (e.g., `/media/...`).
- If the API returns a relative media path, build the full URL as `BASE_URL + media_path`.

## Notes / Duplicates
- There are duplicate routes for some actions (e.g., `/api/create-post/` vs `/api/posts/create/`, and `/api/user/<user_id>/posts/` vs `/api/posts/user/<user_id>/`).
- Some endpoints do not enforce auth (no permission class set). If you need to lock them down, add permissions in the backend.