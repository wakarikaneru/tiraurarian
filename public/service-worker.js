const CACHE_NAME = "tirauraria-cache-v0.1.1";

console.log('Hello from service-worker.js');

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll([
        '/offline',
        '/images/no-image.png'
      ]);
    })
  );
});
