import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import Footer from "../src/frontend/components/footer";

describe("Footer Component", () => {
  it("renders the footer element", () => {
    render(<Footer />);
    const footer = screen.getByTestId("footer");
    expect(footer).toBeInTheDocument();
  });

  it("displays the correct copyright text", () => {
    const currentYear = new Date().getFullYear();
    render(<Footer />);
    expect(
      screen.getByText(`Copyright © ${currentYear} LoremIpsum.jl Contributors`)
    ).toBeInTheDocument();
  });

  it("contains a link to the MIT License", () => {
    render(<Footer />);
    const licenseLink = screen.getByRole("link", { name: "MIT License" });
    expect(licenseLink).toBeInTheDocument();
    expect(licenseLink).toHaveAttribute(
      "href",
      "https://opensource.org/license/mit"
    );
    expect(licenseLink).toHaveAttribute("target", "_blank");
  });
});
