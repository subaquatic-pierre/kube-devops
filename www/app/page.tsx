import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { DemoSection } from "@/components/demo-section";
import {
  ArrowRight,
  Box,
  Code,
  Cpu,
  Database,
  Github,
  Sparkles,
} from "lucide-react";

const features = [
  {
    icon: Box,
    title: "FastAPI Backend",
    description:
      "High-performance Python API with automatic OpenAPI docs and SQLAlchemy ORM.",
  },
  {
    icon: Code,
    title: "Next.js Frontend",
    description:
      "React framework with App Router, TypeScript, and shadcn/ui components.",
  },
  {
    icon: Database,
    title: "PostgreSQL + SQLite",
    description:
      "Production-grade PostgreSQL and lightweight SQLite for development.",
  },
  {
    icon: Cpu,
    title: "Docker Compose",
    description:
      "One-command local development with hot-reload for both frontend and backend.",
  },
];

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col">
      {/* ─── Header ─────────────────────────────────────────────── */}
      <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container flex h-16 items-center justify-between">
          <div className="flex items-center gap-2 font-bold text-xl">
            <Sparkles className="h-5 w-5 text-primary" />
            <span>Project</span>
          </div>
          <nav className="flex items-center gap-4">
            <Button variant="ghost" size="sm" asChild>
              <a href="#features">Features</a>
            </Button>
            <Button variant="ghost" size="sm" asChild>
              <a href="#demo">Live Demo</a>
            </Button>
            <Button size="sm" asChild>
              <a href="https://github.com" target="_blank" rel="noreferrer">
                <Github className="mr-2 h-4 w-4" />
                GitHub
              </a>
            </Button>
          </nav>
        </div>
      </header>

      {/* ─── Hero ───────────────────────────────────────────────── */}
      <section className="flex-1">
        <div className="container relative flex flex-col items-center gap-8 pt-24 pb-16 text-center md:pt-32 lg:gap-12">
          <Badge variant="secondary" className="gap-1 px-4 py-1.5 text-sm">
            <Sparkles className="h-3.5 w-3.5" />
            Project Starter Template
          </Badge>

          <h1 className="max-w-4xl text-4xl font-bold tracking-tight sm:text-5xl md:text-6xl lg:text-7xl">
            Build your next project
            <br />
            <span className="text-primary">fast</span>, with the right stack
          </h1>

          <p className="max-w-[42rem] text-lg text-muted-foreground sm:text-xl">
            A production-ready template combining FastAPI, Next.js, Docker
            Compose, and shadcn/ui — so you can focus on what matters.
          </p>

          <div className="flex flex-wrap items-center justify-center gap-4">
            <Button size="lg" asChild>
              <a href="#features">
                Get Started <ArrowRight className="ml-2 h-4 w-4" />
              </a>
            </Button>
            <Button size="lg" variant="outline" asChild>
              <a
                href="https://github.com"
                target="_blank"
                rel="noreferrer"
              >
                <Github className="mr-2 h-4 w-4" />
                View on GitHub
              </a>
            </Button>
          </div>
        </div>
      </section>

      {/* ─── Features ──────────────────────────────────────────── */}
      <section id="features" className="border-t bg-muted/40 py-20">
        <div className="container">
          <div className="mx-auto max-w-2xl text-center">
            <h2 className="text-3xl font-bold tracking-tight sm:text-4xl">
              Everything you need to ship
            </h2>
            <p className="mt-4 text-lg text-muted-foreground">
              A curated stack that just works — no assembly required.
            </p>
          </div>

          <div className="mt-16 grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {features.map((feature) => {
              const Icon = feature.icon;
              return (
                <Card key={feature.title} className="border-0 shadow-sm">
                  <CardHeader>
                    <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10">
                      <Icon className="h-6 w-6 text-primary" />
                    </div>
                    <CardTitle className="mt-4 text-xl">
                      {feature.title}
                    </CardTitle>
                    <CardDescription className="text-base">
                      {feature.description}
                    </CardDescription>
                  </CardHeader>
                  <CardContent />
                </Card>
              );
            })}
          </div>
        </div>
      </section>

      {/* ─── Live Demo ─────────────────────────────────────────── */}
      <DemoSection />

      {/* ─── CTA ────────────────────────────────────────────────── */}
      <section className="border-t py-20">
        <div className="container text-center">
          <h2 className="text-3xl font-bold tracking-tight sm:text-4xl">
            Ready to build?
          </h2>
          <p className="mx-auto mt-4 max-w-xl text-lg text-muted-foreground">
            Clone the repo, run <code className="rounded bg-muted px-2 py-0.5 text-sm font-mono">docker compose up</code>, and start coding.
          </p>
          <div className="mt-8 flex items-center justify-center gap-4">
            <Button size="lg" asChild>
              <a href="https://github.com" target="_blank" rel="noreferrer">
                <Github className="mr-2 h-4 w-4" />
                Clone from GitHub
              </a>
            </Button>
          </div>
        </div>
      </section>

      {/* ─── Footer ────────────────────────────────────────────── */}
      <footer className="border-t py-8">
        <div className="container flex flex-col items-center justify-between gap-4 sm:flex-row">
          <p className="text-sm text-muted-foreground">
            &copy; {new Date().getFullYear()} Project Starter. MIT License.
          </p>
          <div className="flex items-center gap-4 text-sm text-muted-foreground">
            <span>Built with</span>
            <span className="flex items-center gap-1">
              <Sparkles className="h-3.5 w-3.5 text-primary" />
              Next.js
            </span>
            <span className="flex items-center gap-1">
              <Code className="h-3.5 w-3.5 text-primary" />
              FastAPI
            </span>
          </div>
        </div>
      </footer>
    </div>
  );
}
