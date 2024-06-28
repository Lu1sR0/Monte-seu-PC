'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "7ebb82de19f3c226b77381a8b6c0d7e8",
"assets/AssetManifest.bin.json": "f955967544556d50ad1fd6bbd6558de1",
"assets/AssetManifest.json": "09235bbd81e5a92922b6903c0ea507c0",
"assets/assets/amd.jpg": "aa56f52cdcf5b9ebe35ef90ef858d980",
"assets/assets/amd1.jpg": "3a324bca6eaade5b9321b8253b2546df",
"assets/assets/amd2.jpg": "caf07942300827bc06023196ec18f022",
"assets/assets/case.jpg": "2a3370e32b2c817d600f56956dba75d4",
"assets/assets/case1.jpg": "577081b25bbfef55c728f4b72a48a7bc",
"assets/assets/case2.jpg": "37891bb197e7fd06be3e5dc6aab030bb",
"assets/assets/case3.jpg": "219ce803d0a9a77e1c2be0e744629265",
"assets/assets/cooler.jpg": "134bc49b098293a344d2ae3c98d27cc3",
"assets/assets/cooler1.jpg": "c0dfd52d3465765ca35dde06d520fab5",
"assets/assets/cooler2.jpg": "5720144dad43d70b80655817ed97576a",
"assets/assets/cooler3.jpg": "9cc75e94b3dc8c14e26db0b52aaa9c49",
"assets/assets/cooler4.jpg": "cd77bcedac7fdeb7c88748413ad08059",
"assets/assets/cooler5.jpg": "a0b342d07489f303f028e64a66fd4c4b",
"assets/assets/espaco.jpg": "c32d649b58e5cf17f6d75430e9856634",
"assets/assets/espaco1.jpg": "93d43fcb5325ec6435e094796fb7e5af",
"assets/assets/espaco2.jpg": "4a19e0d11c5ef22caca0abde08c98066",
"assets/assets/espaco3.jpg": "8bc63b2cee4b2e24396549207c8b6a3b",
"assets/assets/espaco4.jpg": "b08b38273a01e8bf8d076301771fece1",
"assets/assets/espaco5.jpg": "9d4a931ba7c5dfe7b220872dee89132a",
"assets/assets/facebook_icon.png": "692ed857716d05ef9f96cb2d140d159a",
"assets/assets/fonte.jpg": "100f6293c8c9b8b562d5774781eff5af",
"assets/assets/fonte1.jpg": "016c3ab61c8b0ea9c64243cb568c6388",
"assets/assets/fonte2.jpg": "09e190f55f8ac27bd782975399ae7363",
"assets/assets/fonte3.jpg": "b483fc90eb330db0f1bec17163487c92",
"assets/assets/fonts/Poppins/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/assets/google_icon.png": "8d622d0180322a449dbb2ab274343296",
"assets/assets/gpu.jpg": "4320c00f5bff4ecd8aa74c3a72411399",
"assets/assets/gpu1.jpg": "543697205c38bb60fbd0235ead658282",
"assets/assets/gpu2.jpg": "4472d57a27fc5204ecf8f5799b445f31",
"assets/assets/gpu3.jpg": "c261f55f6d9f8ceb63755a694942b233",
"assets/assets/gpu4.jpg": "fcd876accb4418f6265ef8ae72fe62ae",
"assets/assets/gpu5.jpg": "7fbc2734d84b487f92647d656f6fa3b4",
"assets/assets/intel.jpg": "79d208b4a102e2280f182ceb8aa69427",
"assets/assets/intel1.jpg": "16a3003c98cd6b090457a8fe3d013ed3",
"assets/assets/intel3.jpg": "1cab15eb0cb68f1970954764a2b85dca",
"assets/assets/logoamefesthdeitadafundobranco.png": "25065225cc8b839887565cdffa24e950",
"assets/assets/logoamefesthfinal.png": "b57d2622c5ce0b8eba221da4ccdde12e",
"assets/assets/lottie/Animation%2520-%25201718151796539.json": "dfaeb65b119c13f03cf2f7e239e30d8e",
"assets/assets/montarpc.jpg": "774ed80fb2af20a50e02e29bfbe74465",
"assets/assets/pcbuild.jpg": "14022f571ad05fb6756ebeccb4ed7398",
"assets/assets/ram.jpg": "cd0326264dfecb82a096d3e0c8cd02c0",
"assets/assets/ram1.jpg": "c3f8c19204df68687acc6f48636639fd",
"assets/assets/ram2.jpg": "04695c817628274e63f1bcb557e55cd7",
"assets/assets/ram3.jpg": "5443caa6056629dc98d3c450252ab060",
"assets/assets/ram4.jpg": "5fd921b3df12515786aad46c9677688c",
"assets/assets/ram5.jpg": "0bcb29307b758712b26580d3f9d6054f",
"assets/assets/teladefundo.jpg": "ec6db6210e205d7e9fc42e95ff3e9c60",
"assets/FontManifest.json": "7168722cfbde68a7bbc7135e0fca95a6",
"assets/fonts/MaterialIcons-Regular.otf": "4800ea8b3809b0b1572e90555cb3a750",
"assets/NOTICES": "45088b169bfee444bde65c9068fcf67c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "b02e7bc40bc461a7683a2123f497bce9",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "38c6616487ae99f9e006d8d1356267e9",
"/": "38c6616487ae99f9e006d8d1356267e9",
"main.dart.js": "4c885c20cf45b534ec659233a154205c",
"manifest.json": "b322cbf97e238c8457a249ce3f2917c8",
"version.json": "83f259ecdafdecda6c26594f887410a5"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
