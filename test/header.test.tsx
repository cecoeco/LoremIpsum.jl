import { render, screen, fireEvent, cleanup } from "@testing-library/react";
import { describe, it, expect, beforeAll, vi, afterEach } from "vitest";
import Header from "../src/frontend/components/header";

// Mock window.matchMedia for theme tests
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

describe("Header Component", () => {
  // Test if the Header element renders correctly
  it("renders the Header element", () => {
    render(<Header />);
    const header = screen.getByTestId("header");
    expect(header).toBeInTheDocument();
  });

  // Test if the Theme toggle button exists
  it("renders the theme toggle button", () => {
    render(<Header />);
    const themeButton = screen.getByTitle("Toggle theme");
    expect(themeButton).toBeInTheDocument();
  });

  // Test if clicking the theme button toggles the theme
  it("changes theme when the theme button is clicked", () => {
    render(<Header />);
    const themeButton = screen.getByTitle("Toggle theme");

    // Initially, it should show the Sun icon
    const sunIcon = screen.getByTestId("sun-icon");
    expect(sunIcon).toBeInTheDocument();

    // Simulate the button click to toggle the theme
    fireEvent.click(themeButton);

    // After clicking, it should show the Moon icon
    const moonIcon = screen.getByTestId("moon-icon");
    expect(moonIcon).toBeInTheDocument();
  });

  // Test if the GitHub button renders and links correctly
  it("renders the GitHub button and links to the correct URL", () => {
    render(<Header />);
    const githubButton = screen.getByRole("link", {
      name: /GitHub/i,
    });
    expect(githubButton).toBeInTheDocument();
    expect(githubButton).toHaveAttribute("href", "https://github.com/cecoeco/LoremIpsum.jl");
  });

  // Test if the header class changes on scroll
  it("changes header class when scrolled", () => {
    render(<Header />);
    const header = screen.getByTestId("header");

    // Simulate scrolling
    fireEvent.scroll(window, { target: { scrollY: 100 } });
    expect(header).toHaveClass("scrolled");

    // Simulate scrolling back to top
    fireEvent.scroll(window, { target: { scrollY: 0 } });
    expect(header).not.toHaveClass("scrolled");
  });
});
