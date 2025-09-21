DATOU Real-Time Messaging System

A production-ready messaging system built with Flutter and Supabase, featuring real-time updates, file attachments, conversation management, and enterprise-level reliability.

🚀 Features
Core Messaging

Direct Messages: One-on-one conversations

Group Chats: Multi-user conversations with admin/moderator roles

Conversation List: Chronological ordering with last-message previews & unread indicators

Search: Find conversations or participants

Real-Time Capabilities

Instant Delivery via Supabase real-time subscriptions

Typing Indicators

Read Receipts

Online Presence

Message Management

Optimistic UI updates (instant rendering, rollback on failure)

Edit & delete messages (with timestamps)

Reply support & message search

File attachments (images, documents) with upload progress

Participant Management

Role-based permissions (admin, moderator, member)

Blocking & muting

Join/leave tracking

Last-read message tracking

🏗️ Tech Stack

Frontend

Flutter (with Riverpod for state management)

GoRouter for navigation

CachedNetworkImage for optimized media

File & Image Picker for attachments

Backend

Supabase (PostgreSQL + Auth + Realtime)

Row Level Security (RLS) for access control

Supabase Storage for file hosting

🔒 Security & Performance

Strict RLS policies for privacy and access control

Cached avatars/media for performance

Pagination & lazy loading

Debounced typing indicators

Graceful offline state handling & retries

📊 Database Schema

conversations – chat metadata

messages – individual messages

conversation_participants – user roles & memberships

profiles – user profile info

Relationships

Conversation → Messages (1:N)

Users ↔ Conversations (M:N via participants)

Message → Sender Profile (1:1)

🎯 Recent Improvements

Fixed state management lifecycle issues

Eliminated infinite rebuild loops

Optimized provider management

Smoother navigation & UI responsiveness

🔮 Roadmap

Voice messages (record & playback)

Message reactions (emoji support)

Message threading (reply chains)

Push notifications

End-to-end encryption

📱 Demo

WhatsApp-like UX

Real-time message bubbles

Typing indicators & read receipts

File attachments & search
