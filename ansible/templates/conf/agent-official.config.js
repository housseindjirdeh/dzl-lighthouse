module.exports = {
  collector: {
    type: 'local',
    repositoryPath: process.env.LH_PATH,
  },
  collection: {
    runs: 25,
    urls: [
      'http://localhost:10200/online-only.html',
      'http://localhost:10200/perf/fonts.html',
      'http://localhost:10200/byte-efficiency/tester.html',
      'http://localhost:10200/a11y/a11y_tester.html',
      'https://example.com',
      'https://www.sfgate.com',
      'https://www.theverge.com',
      'https://www.cnn.com',
      'https://www.cnet.com',
      'https://www.amazon.com',
      'https://www.att.com',
      'https://www.hulu.com',
      'https://www.linkedin.com',
      'https://www.facebook.com',
      'https://www.vevo.com',
      'https://www.wikipedia.org',
    ],
  },
  storage: {
    type: 'sql',
    host: '{{ hostvars[groups["masters"][0]].ansible_default_ipv4.address }}',
  },
  lighthouseConfig: {
    extends: 'lighthouse:default',
    settings: {onlyCategories: ['performance', 'accessibility', 'best-practices', 'seo', 'pwa']},
  },
}
