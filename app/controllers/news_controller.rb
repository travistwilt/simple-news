class NewsController < ApplicationController
  def index
  
	require 'rest-client'
	
	@stories = Array.new
	
	#get the latest stories
	@storyIds = RestClient.get 'https://hacker-news.firebaseio.com/v0/newstories.json'
	@storyIds = JSON.parse(@storyIds)
	
	#remove odd or even articles depending on if the user has selected a filter
	params = request.query_parameters
	if params['show'] == 'odd'
		@storyIds.reject!.with_index{|_, i| i.even?}
	else 
		@storyIds.reject!.with_index{|_, i| i.odd?}
	end
	
	#keep the first 30 stories
	@storyIds = @storyIds.take(30)
	
	#query the api to retrieve the stories that correspond to the ids
	#the api can unfortunately only return one story at a time
	@storyIds.each { |id|
		@story = RestClient.get 'https://hacker-news.firebaseio.com/v0/item/'+id.to_s+'.json'
		@story = JSON.parse(@story)
		
		#generate images from article link
		og = OpenGraph.new(@story['url'])
		@story.merge!("img": og.images[0])
		puts og.images

		@stories.push(@story)
		puts @story
	}
	
  end
end
