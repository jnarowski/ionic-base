module.exports = (grunt) ->
 
  # configuration
  grunt.initConfig

    # grunt copy
    copy:
      ionic: # Copy Ionic assets
        files:
          'build/vendor/ionic/js/ionic.bundle.js': 'vendor/ionic/js/ionic.bundle.js'
          'build/vendor/ionic/fonts/ionicons.eot': 'vendor/ionic/fonts/ionicons.eot'
          'build/vendor/ionic/fonts/ionicons.svg': 'vendor/ionic/fonts/ionicons.svg'
          'build/vendor/ionic/fonts/ionicons.ttf': 'vendor/ionic/fonts/ionicons.ttf'
          'build/vendor/ionic/fonts/ionicons.woff': 'vendor/ionic/fonts/ionicons.woff'
      angular:
        files:
          'build/vendor/angular-resource/angular-resource.js': 'vendor/angular-resource/angular-resource.js'
          'build/vendor/angular/angular-mocks.js': 'vendor/angular/angular-mocks.js'
      underscore:
        files:
          'build/vendor/underscore/underscore.js': 'vendor/underscore/underscore.js'
      moment:
        files:
          'build/vendor/moment/moment-with-langs.min.js': 'vendor/moment/min/moment-with-langs.min.js'
      srcHtml: # Copy HTML sources, currently only index.html
        expand: true
        cwd: 'src/'
        src: ['**/*.html', '!**/*.tpl.html'] # Copy all HTML files but leave templates that are converted into JS by html2js
        dest: 'build/'
      www: # Copy all files from build to www
        expand: true
        cwd: 'build/'
        src: '**/*'
        dest: 'www/'

    # grunt concat
    concat:
      srcJs: # not used as we have only CoffeeScript files
        options:
          separator: ';'
        src: 'src/app/**/*.js'
        dest: 'build/karmacrm.js'

    # grunt html2js
    html2js:
      app: # convert all Algular html templates into a JS file for fast loading and the ability to test with the file:// protocol
        options:
          base: 'src/app/'
          module: 'templates-app'
        src: ['src/app/**/*.tpl.html']
        dest: 'build/templates-app.js'

    # grunt sass
    sass:
      ionic: # process Ionic SCSS files into a single CSS
        files:
          'build/vendor/ionic/css/ionic.css': 'vendor/ionic/scss/ionic.scss'
           
    # grunt coffee
    coffee:
      compile:
        src: ['src/app/**/*.coffee', '!src/app/**/*.test.coffee']
        dest: 'build/karmacrm.coffee.js'
        ext: 'coffee.js'
        options:
          bare: true
          preserve_dirs: true
      tests:
        src: 'src/app/**/*.test.coffee'
        dest: 'build/karmacrm.test.coffee.js'
        ext: 'coffee.js'
        options:
          bare: true
          preserve_dirs: true

    # karma test launcher
    karma:
      unit:
        configFile: 'karma.config.js'

    # grunt watch
    watch:
      html:
        files: ['src/**/*.html', '!src/**/*.tpl.html']
        tasks: ['copy:srcHtml']
      concatSrcJs: # not used as we have only CoffeeScript files
        files: '<%= concat.srcJs.src %>'
        tasks: ['concat:srcJs']
      html2js:
        files: '<%= html2js.app.src %>'
        tasks: ['html2js']
      sass: # project SCSS structure to be defined
        files: ['vendor/ionic/**/*.scss']
        tasks: ['sass:ionic']
      coffee:
        files: '<%= coffee.compile.src %>'
        tasks: ['coffee']
      grunt:
        files: 'Gruntfile.coffee'
        tasks: ['vendor', 'src']
      options:
        livereload: true
 
  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-html2js'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-karma'
 
  # tasks
  grunt.registerTask 'ionic', ['sass:ionic', 'copy:ionic']
  grunt.registerTask 'vendor', ['ionic', 'copy:angular', 'copy:underscore', 'copy:moment']

  grunt.registerTask 'src', ['html2js', 'coffee', 'copy:srcHtml']

  grunt.registerTask 'www', ['copy:www'] # currently publishing to www is only a copy of build but could include minification

  grunt.registerTask 'default', ['vendor', 'src', 'watch']
  
  grunt.registerTask 'test', ['karma']
  
  grunt.registerTask 'publish', ['vendor', 'src', 'www']