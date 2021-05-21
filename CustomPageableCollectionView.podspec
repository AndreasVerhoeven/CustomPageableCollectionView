Pod::Spec.new do |s|
    s.name             = 'CustomPageableCollectionView'
    s.version          = '1.0.0'
    s.summary          = 'A CollectionView that supports custom paging'
    s.homepage         = 'https://github.com/AndreasVerhoeven/CustomPageableCollectionView'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andreas Verhoeven' => 'cocoapods@aveapps.com' }
    s.source           = { :git => 'https://github.com/AndreasVerhoeven/CustomPageableCollectionView.git', :tag => s.version.to_s }
    s.module_name      = 'CustomPageableCollectionView'

    s.swift_versions = ['5.0']
    s.ios.deployment_target = '11.0'
    s.source_files = 'Sources/*.swift'
end
