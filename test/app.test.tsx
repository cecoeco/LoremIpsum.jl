import { describe, it, expect, beforeAll, afterEach, vi } from "vitest";
import { render, screen, cleanup } from "@testing-library/react";
import App from "../src/frontend/app";

// Mock window.matchMedia for tests
beforeAll(() => {
  global.matchMedia = vi.fn().mockImplementation(() => ({
    matches: false,
    addListener: vi.fn(),
    removeListener: vi.fn(),
  }));
});

afterEach(() => {
  cleanup();
});

describe("App Component", () => {
  it("renders the Header and Footer components", () => {
    render(<App />);

    expect(screen.getByTestId("header")).toBeInTheDocument();
    expect(screen.getByTestId("footer")).toBeInTheDocument();
  });
});
