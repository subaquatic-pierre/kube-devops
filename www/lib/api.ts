export interface Item {
  id: number;
  title: string;
  description: string | null;
  completed: boolean;
  created_at: string;
  updated_at: string | null;
}

export interface CreateItemPayload {
  title: string;
  description?: string | null;
  completed?: boolean;
}

const BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:5000";

async function request<T>(
  path: string,
  options?: RequestInit,
): Promise<T> {
  const res = await fetch(`${BASE_URL}${path}`, {
    headers: {
      "Content-Type": "application/json",
      ...options?.headers,
    },
    ...options,
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`API ${res.status}: ${body}`);
  }

  // 204 No Content
  if (res.status === 204) return undefined as T;

  return res.json();
}

// ─── Items ─────────────────────────────────────────────────────────

export function listItems(): Promise<Item[]> {
  return request("/items");
}

export function getItem(id: number): Promise<Item> {
  return request(`/items/${id}`);
}

export function createItem(payload: CreateItemPayload): Promise<Item> {
  return request("/items", {
    method: "POST",
    body: JSON.stringify(payload),
  });
}

export function updateItem(
  id: number,
  payload: Partial<CreateItemPayload>,
): Promise<Item> {
  return request(`/items/${id}`, {
    method: "PUT",
    body: JSON.stringify(payload),
  });
}

export function deleteItem(id: number): Promise<void> {
  return request(`/items/${id}`, { method: "DELETE" });
}
