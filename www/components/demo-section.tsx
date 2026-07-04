"use client";

import { useEffect, useState, FormEvent } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  CheckCircle2,
  Circle,
  Loader2,
  Plus,
  Trash2,
  Wifi,
  WifiOff,
} from "lucide-react";
import type { Item } from "@/lib/api";
import {
  listItems,
  createItem,
  deleteItem,
} from "@/lib/api";

export function DemoSection() {
  const [items, setItems] = useState<Item[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [apiOk, setApiOk] = useState<boolean | null>(null);

  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [submitting, setSubmitting] = useState(false);

  // ── Health check on mount ───────────────────────────────────
  useEffect(() => {
    fetch(`${process.env.NEXT_PUBLIC_API_URL || "http://localhost:5000"}/health`)
      .then((r) => r.json())
      .then((d) => setApiOk(d.status === "ok"))
      .catch(() => setApiOk(false));
  }, []);

  // ── Fetch items ─────────────────────────────────────────────
  const fetchItems = async () => {
    try {
      setError(null);
      const data = await listItems();
      setItems(data);
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : "Failed to load items");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchItems();
  }, []);

  // ── Create item ─────────────────────────────────────────────
  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;

    setSubmitting(true);
    try {
      const created = await createItem({
        title: title.trim(),
        description: description.trim() || null,
      });
      setItems((prev) => [created, ...prev]);
      setTitle("");
      setDescription("");
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : "Failed to create item");
    } finally {
      setSubmitting(false);
    }
  };

  // ── Delete item ─────────────────────────────────────────────
  const handleDelete = async (id: number) => {
    try {
      await deleteItem(id);
      setItems((prev) => prev.filter((item) => item.id !== id));
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : "Failed to delete item");
    }
  };

  return (
    <section id="demo" className="border-t py-20">
      <div className="container">
        <div className="mx-auto max-w-2xl text-center">
          <h2 className="text-3xl font-bold tracking-tight sm:text-4xl">
            Live API Demo
          </h2>
          <p className="mt-4 text-lg text-muted-foreground">
            This section talks to the running FastAPI backend. Add and manage
            items in real time.
          </p>

          {/* Connection status */}
          <div className="mt-4 flex items-center justify-center gap-2 text-sm">
            {apiOk === null ? (
              <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
            ) : apiOk ? (
              <Badge
                variant="outline"
                className="gap-1 border-green-300 text-green-700"
              >
                <Wifi className="h-3 w-3" />
                API connected
              </Badge>
            ) : (
              <Badge
                variant="outline"
                className="gap-1 border-red-300 text-red-700"
              >
                <WifiOff className="h-3 w-3" />
                API unreachable
              </Badge>
            )}
          </div>
        </div>

        {/* ── Create form ─────────────────────────────────── */}
        <form
          onSubmit={handleSubmit}
          className="mx-auto mt-10 flex max-w-xl flex-col gap-3 sm:flex-row"
        >
          <input
            type="text"
            placeholder="Item title…"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            required
            className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
          />
          <input
            type="text"
            placeholder="Description (optional)"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
          />
          <Button type="submit" disabled={submitting || !title.trim()}>
            {submitting ? (
              <Loader2 className="mr-1 h-4 w-4 animate-spin" />
            ) : (
              <Plus className="mr-1 h-4 w-4" />
            )}
            Add
          </Button>
        </form>

        {/* ── Error banner ────────────────────────────────── */}
        {error && (
          <p className="mx-auto mt-4 max-w-xl rounded-md bg-destructive/10 p-3 text-center text-sm text-destructive">
            {error}
          </p>
        )}

        {/* ── Items list ──────────────────────────────────── */}
        <div className="mt-10">
          {loading ? (
            <div className="flex items-center justify-center gap-2 py-16 text-muted-foreground">
              <Loader2 className="h-5 w-5 animate-spin" />
              Loading items…
            </div>
          ) : items.length === 0 ? (
            <div className="py-16 text-center text-muted-foreground">
              <Circle className="mx-auto h-10 w-10" />
              <p className="mt-3 font-medium">No items yet</p>
              <p className="text-sm">
                Create one using the form above.
              </p>
            </div>
          ) : (
            <div className="mx-auto grid max-w-2xl gap-3">
              {items.map((item) => (
                <Card key={item.id} className="border shadow-none">
                  <CardHeader className="flex flex-row items-start justify-between p-4 pb-2">
                    <div className="flex items-start gap-3">
                      {item.completed ? (
                        <CheckCircle2 className="mt-0.5 h-5 w-5 shrink-0 text-green-600" />
                      ) : (
                        <Circle className="mt-0.5 h-5 w-5 shrink-0 text-muted-foreground" />
                      )}
                      <div>
                        <CardTitle className="text-base font-medium">
                          {item.title}
                        </CardTitle>
                        {item.description && (
                          <CardDescription className="mt-0.5 text-sm">
                            {item.description}
                          </CardDescription>
                        )}
                      </div>
                    </div>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="-mr-2 -mt-2 h-8 w-8 text-muted-foreground hover:text-destructive"
                      onClick={() => handleDelete(item.id)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </CardHeader>
                  <CardContent className="px-4 pb-3 pt-1">
                    <p className="text-xs text-muted-foreground">
                      Created{" "}
                      {new Date(item.created_at).toLocaleDateString(undefined, {
                        year: "numeric",
                        month: "short",
                        day: "numeric",
                        hour: "2-digit",
                        minute: "2-digit",
                      })}
                    </p>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </div>
      </div>
    </section>
  );
}
