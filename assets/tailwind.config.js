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
      xs: "0.75rem",
      sm: "0.875rem",
      base: "1rem",
      lg: "1.125rem",
      xl: "1.25rem",
      "2xl": "1.5rem",
      "3xl": "1.875rem",
      "4xl": "2.25rem",
      "5xl": "3rem",
      "6xl": "4rem",
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
