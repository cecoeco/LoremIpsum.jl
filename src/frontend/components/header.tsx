import React, { useState, useEffect } from "react";
import Sun from "../assets/svgs/sun.svg?react";
import Moon from "../assets/svgs/moon.svg?react";

import "../assets/css/header.css";

const applyTheme = (isLightTheme: boolean) => {
  const theme = isLightTheme ? "light" : "dark";
  document.documentElement.setAttribute("data-theme", theme);
};

const ThemeButton: React.FunctionComponent = () => {
  const [isLightTheme, setIsLightTheme] = useState(true);

  const toggleTheme = () => {
    setIsLightTheme((prev) => {
      const newTheme = !prev;
      applyTheme(newTheme);
      return newTheme;
    });
  };

  useEffect(() => {
    const prefersDarkMode = window.matchMedia("(prefers-color-scheme: dark)").matches;
    setIsLightTheme(!prefersDarkMode);
    applyTheme(!prefersDarkMode);
  }, []);

  return (
    <button
      title="Toggle theme"
      className="theme-button"
      onClick={toggleTheme}
      aria-label="Toggle theme"
    >
      {isLightTheme ? (
        <Sun className="theme-button-icon" data-testid="sun-icon" />
      ) : (
        <Moon className="theme-button-icon" data-testid="moon-icon" />
      )}
    </button>
  );
};

const GithubButton: React.FunctionComponent = () => {
  return (
    <a
      href="https://github.com/cecoeco/LoremIpsum.jl"
      target="_blank"
      rel="noopener noreferrer"
      className="github-button"
    >
      <img
        src="https://img.shields.io/github/stars/cecoeco/LoremIpsum.jl?style=social"
        alt="GitHub stars"
      />
    </a>
  );
};

const Header: React.FunctionComponent = () => {
  const [isScrolled, setIsScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => setIsScrolled(window.scrollY > 0);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <header className={isScrolled ? "header scrolled" : "header"} data-testid="header">
      <h1 className="header-title">LoremIpsum.jl</h1>
      <ThemeButton />
      <GithubButton />
    </header>
  );
};

export default Header;
