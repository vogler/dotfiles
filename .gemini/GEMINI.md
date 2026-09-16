# Global Rules

## File Paths & Portability
- **Never use machine-specific absolute paths**: Do not use local, user-specific filesystem paths (e.g. `/Users/<username>/...`, `C:\...`, or `file:///Users/...`) in generated documentation, plans, slide content, markdown links, code comments, or task outputs.
- **Always use relative paths**: Always format file references and links as portable relative paths (relative to the project root or the referencing file) so the folder structure and documents can be seamlessly shared across teammates, different machines, and version control.

## Modern Tooling & Languages (New Projects)
- **Language Preference**: Default to strongly-typed languages with static checking. Prefer **TypeScript** over JavaScript over Python.
- **JS / TS Runtime & Package Manager**: Prefer **`bun`** over `node`, `npm`, or `pnpm`.
- **Python Tooling**: Prefer **`uv`** for package management, virtual environments, and project execution over `venv`, `poetry`, or `pipenv`.
- **Web Applications**: Prefer **Next.js** (App Router). Default to Server-Side Rendering (SSR) and Server Components; only use `"use client"` when interactive state or browser APIs strictly require it.

## Architecture & Coding Style
- **Functional Paradigm over OOP**: Write clean, declarative, functional code. Rely on structured modules and pure functions rather than complex class hierarchies, side-effectful OOP constructs, or mutable state.
- **Top-Down Structure & SOLID**: Organize files top-down (high-level orchestrators and exported entry points first, followed by lower-level pure details). Keep functions focused on a single responsibility.
- **No Non-descriptive Utility Files**: Avoid creating vague utility dumping grounds like `helpers.ts`, `utils.ts`, or `types.ts`. Place helper functions and types in the domain module or component where they are conceptually relevant.
- **Type Consolidation & Single Source of Truth**: Consolidate types and avoid duplicate definitions. Where schemas (such as Zod) are used, derive TypeScript types directly via schema inference (`z.infer<typeof schema>`).
- **Clean Interfaces**: Prefer typed parameter objects over long positional parameter lists. Treat inputs and props as read-only.
- **Fast Local Verification**: Use fast type-checking and linting (e.g., `bun check`, `tsc --noEmit`) during development rather than repeatedly running full production builds.
