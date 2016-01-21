Pod::Spec.new do |s|
	s.name = "IQAsyncImage"
	s.version = "1.0.1"
	s.summary = "Asynchronous Image Loading Framework with progress and text initial placeholder support"
	s.homepage = "https://github.com/hackiftekhar/IQAsyncImage"
	s.screenshots = "https://raw.githubusercontent.com/hackiftekhar/IQAsyncImage/master/Screenshot/Screenshot.png"
	s.license = 'MIT'
	s.author = { "Iftekhar Qurashi" => "hack.iftekhar@gmail.com" }
	s.platform = :ios, '7.0'
	s.source = { :git => "https://github.com/hackiftekhar/IQAsyncImage.git", :tag => "v1.0.1" }
    s.source_files = 'IQAsyncImage/**/*.{h,m}'
    s.dependency 'IQURLConnection'
    s.dependency 'IQNetworkTaskManager'
    s.dependency 'IQCircularProgressView'

    s.requires_arc = true
end
