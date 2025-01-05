import React from 'react';

import "../assets/css/footer.css";

const Footer: React.FC = () => {
  return (
    <footer className="footer" data-testid="footer">
      <p className="footer-text">
        Copyright © {new Date().getFullYear()} LoremIpsum.jl Contributors
      </p>
      <a href="https://opensource.org/license/mit" target="_blank">
        MIT License
      </a>
    </footer>
  );
};

export default Footer;