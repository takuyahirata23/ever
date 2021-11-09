module.exports = {
  purge: [
    "./js/**/*.js",
    "../lib/cn_coding_web/**/*.html",
    "../lib/cn_coding_web/**/*.ex",
    "../lib/cn_coding_web/**/*.eex",
    "../lib/cn_coding_web/**/*.heex",
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    fontFamily: {
      sans: ["Inter", "sans-serif"],
      serif: ["Merriweather", "serif"],
    },
    fontSize: {
      xs: ["0.75rem", 1],
      sm: ["0.875rem", 1],
      base: ["1rem", 1],
      lg: ["1.125rem", 1],
      xl: ["1.25rem", 1],
      "2xl": ["1.5rem", 1],
      "3xl": ["1.875rem", 1],
      "4xl": ["2.25rem", 1],
      "5xl": ["3rem", 1],
      "6xl": ["4rem", 1],
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
