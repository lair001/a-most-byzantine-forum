require 'spec_helper'

describe 'Thread' do 

  before do
    @thread = Thread.create(title: "test 123")
  end

  it 'can slug the title' do
    expect(@thread.slug).to eq("test-123")
  end

  it 'can find a thread based on the slug' do
    slug = @thread.slug
    expect(Thread.find_by_slug(slug).title).to eq("test 123")
  end

  it 'knows when it was created' do 
    expect(@user.created_at).to be_a(DateTime)
  end

  it 'knows when it was last updated' do 
    expect(@user.updated_at).to be_a(DateTime)
  end

end